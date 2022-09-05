import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wordl, WordlWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "t1449Y26SbJbM2ivYL4NuabsGq7hZvSBDp3QN6r6lk1Wki4NweMXUcS8MCz23MSG",
  server: false

# In test we don't send emails.
config :wordl, Wordl.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
