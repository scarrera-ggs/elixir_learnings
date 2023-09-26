import Config

config :configs_app,
  names: ["address1", "address2"]

import_config "#{config_env()}.exs"
