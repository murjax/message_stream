defmodule MessageStream.Repo do
  use Ecto.Repo,
    otp_app: :message_stream,
    adapter: Ecto.Adapters.Postgres
end
