import Config

config :configs_app,
  addresses: ["address1", "address2"]

import_config "#{config_env()}.exs"
