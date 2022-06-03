import Config

config :notifying_mailer_service, NotifyingMailerService.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "localhost",
  hostname: "dev.stasm.eu",
  port: 25
