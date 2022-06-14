import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :user_http_authenticating_service, UserHttpAuthenticatingServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "gYuIbfKAn/SekhmUr2CT+CVQLV7HcgJXGP0isml3OZWsv5wvYWBc7AiNy9hoF5T5",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
