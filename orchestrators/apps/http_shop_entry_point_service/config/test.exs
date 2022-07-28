import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :http_shop_entry_point_service, HttpShopEntryPointServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "arybjl6E4RXCNevliG/FErZ24/MkJFmrVFTIryG3IEFPNWziu8HDZHmKTG+ikZRh",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
