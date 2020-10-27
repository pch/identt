SMTP_SETTINGS = {
  address: ENV.fetch("SMTP_ADDRESS"),
  authentication: :plain,
  domain: ENV.fetch("SMTP_DOMAIN"),
  enable_starttls_auto: true,
  user_name: ENV.fetch("SMTP_USERNAME"),
  password: ENV.fetch("SMTP_PASSWORD"),
  port: ENV.fetch("SMTP_PORT")
}.freeze
