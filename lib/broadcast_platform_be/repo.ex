defmodule BroadcastPlatformBe.Repo do
  use Ecto.Repo,
    otp_app: :broadcast_platform_be,
    adapter: Ecto.Adapters.Postgres
end
