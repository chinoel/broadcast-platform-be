defmodule BroadcastPlatformBeWeb.SignalingChannel do
  use Phoenix.Channel

  @impl true
  def join("signaling:lobby", _params, socket) do
    IO.puts("Client joined signaling channel")
    {:ok, socket}
  end

  # 호스트가 채널에 join 요청
  def handle_in("join_host", %{"id" => host_id}, socket) do
    IO.inspect(host_id, label: "Host joined")
    {:noreply, socket}
  end

  # 시청자가 채널에 join 요청
  def handle_in("join_viewer", %{"id" => viewer_id}, socket) do
    IO.inspect(viewer_id, label: "Viewer joined")

    # 호스트에게 알림 보내기 (브로드캐스트 혹은 특정 대상 전송 가능)
    broadcast!(socket, "viewer_joined", %{"id" => viewer_id})
    {:noreply, socket}
  end

  # 호스트 → 시청자: offer 전달
  def handle_in("offer", %{"offer" => offer, "target" => viewer_id, "from" => host_id}, socket) do
    push(socket, "offer", %{"offer" => offer, "from" => host_id, "target" => viewer_id})
    broadcast!(socket, "offer", %{"offer" => offer, "from" => host_id, "target" => viewer_id})
    {:noreply, socket}
  end

  # 시청자 → 호스트: answer 전달
  def handle_in("answer", %{"answer" => answer, "from" => viewer_id}, socket) do
    broadcast!(socket, "answer", %{"answer" => answer, "from" => viewer_id})
    {:noreply, socket}
  end

  # ICE candidate 교환
  def handle_in("ice_candidate", %{"candidate" => candidate, "from" => from_id, "target" => target_id}, socket) do
    broadcast!(socket, "ice_candidate", %{
      "candidate" => candidate,
      "from" => from_id,
      "target" => target_id
    })
    {:noreply, socket}
  end
end
