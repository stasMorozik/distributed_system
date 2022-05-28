import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :user_http_registration_service, UserHttpRegistrationServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "wSTYPTkerGO1I7YzkR+9tv8ctzgqgj21p+m3/0jr+RbmXe77KLLCgOXywR5LWEjH",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
