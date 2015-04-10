# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Slack::Application.config.secret_key_base = '43d3b773034077bf901495a0cca28fe1097e177a03ac8768dd9cf75c97ae8c8f7d3397f175df659c1af6176b81c8fd197ddfec90969e5e8265e94a3ef9b49b6f'
