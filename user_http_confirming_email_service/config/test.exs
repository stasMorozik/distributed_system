import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :user_http_confirming_email_service, UserHttpConfirmingEmailServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "b6+1mAX561JRjJZX2yZjz+iuOuEl6DuCXJWQehqsmRyKuYs70YLJ6YkzKFsmEkJJ",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
