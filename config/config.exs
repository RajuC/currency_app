# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :currency_app,
  ecto_repos: [CurrencyApp.Repo]

# Configures the endpoint
config :currency_app, CurrencyApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LmWKsfn0oYcPvEyCH5eStwMdPtkdw1NcGeLZGESTIiUyOCP1jE3VHkxuIKTAKKDZ",
  render_errors: [view: CurrencyApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CurrencyApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  binary_id: true,
  migration: false,
  sample_binary_id: "111111111111111111111111"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
