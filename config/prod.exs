use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# IdqAuthDemoWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
config :idq_auth_demo, IdqAuthDemoWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "idq-auth-demo.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

config :idq_auth,
  endpoint: "https://taas.idquanta.com/idqoauth/api/v1/",
  callback_url: System.get_env("IDQ_CALLBACK"),
  client_id: System.get_env("IDQ_ID"),
  client_secret: System.get_env("IDQ_SECRET")
