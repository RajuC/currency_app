use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :currency_app, CurrencyApp.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :currency_app, CurrencyApp.Repo,
  adapter: Mongo.Ecto,
  database: "currency_app_test",
  pool_size: 1
