# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :consolidate,
  ecto_repos: [Consolidate.Repo]

# Configures the endpoint
config :consolidate, ConsolidateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xSq5408frQ5BaacvrL/2RJ3pGoaXMVE/ubfSy4PifZwdgUN8xdWxrxKlqN7u0nEO",
  render_errors: [view: ConsolidateWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Consolidate.PubSub, adapter: Phoenix.PubSub.PG2]

# configures auth?
config :consolidate, Consolidate.Accounts.Guardian,
  issuer: "consolidate",
  secret_key: "xSq5408frQ5BaacvrL/2RJ3pGoaXMVE/ubfSy4PifZwdgUN8xdWxrxKlqN7u0nEO"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
