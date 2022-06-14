import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :user_http_registrating_service, UserHttpRegistratingServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8cJOLJ3NNFOhshjec4E9R1lsoYG8hAg0nVjWhKjTE0BOV9ClkCiVlcvHMr9QrGwI",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
