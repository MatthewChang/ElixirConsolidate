defmodule Consolidate.Repo do
  use Ecto.Repo,
    otp_app: :consolidate,
    adapter: Ecto.Adapters.Postgres
end
