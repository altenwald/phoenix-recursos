use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :vemosla_web, VemoslaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: {:system, "PORT"}],
  url: [host: "${DOMAIN}", port: 443, scheme: "https"],
  cache_static_manifest: "apps/vemosla_web/priv/static/cache_manifest.json",
  server: true,
  secret_key_base: "${SECRET_KEY_BASE}",
  root: "."

# Do not print debug messages in production
config :logger, level: :info

config :vemosla, Vemosla.Repo,
  username: "${POSTGRES_USER}",
  password: "${POSTGRES_PASS}",
  database: "${POSTGRES_DB}",
  hostname: "${POSTGRES_HOST}",
  port: 5432,
  pool_size: 10

config :vemosla_mail, VemoslaMail.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "${MAILGUN_API_KEY}",
  domain: "${MAILGUN_DOMAIN}",
  base_uri: "https://api.eu.mailgun.net/v3"

config :vemosla,
  uploads_files_path: "/home/bombadil/www-data/vemosla.com/FILES",
  uploads_url_path: "/files",
  themoviedb_token: "${THEMOVIEDB_TOKEN}"

config :vemosla_web,
  freegeoip_api_key: "${FREEGEOIP_API_KEY}",
  phoenix_token_salt: "${PHOENIX_TOKEN_SALT}"
