# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :systex76,
  ecto_repos: [Systex76.Repo]

# Configures the endpoint
config :systex76, Systex76Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1At541xjTziUQzcMTSGTf3u2sG0w/wXit4GtAp4vOMjmN6Hub/fQ9iNANpdbxkyg",
  render_errors: [view: Systex76Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Systex76.PubSub,
  live_view: [signing_salt: "oDMsSEnA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

config :systex76, :github,
  username: "",
  personal_access_token: "",
  per_page: 100

config :systex76, Oban,
  repo: Systex76.Repo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 300},
    {Oban.Plugins.Cron,
     crontab: [
       {"0 0 * * *", Systex76.Tasks.ReachTheStars}
     ]}
  ],
  queues: [github: 5]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
