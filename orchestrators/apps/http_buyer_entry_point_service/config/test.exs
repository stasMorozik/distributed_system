import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :http_buyer_entry_point_service, HttpBuyerEntryPointServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "NWOgC8Dh2xFDY7m9GqRgOr0bj7yZ6Wzgc22J7/NSnXoPAQcaFI2+5QT0K8l9d52G",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
