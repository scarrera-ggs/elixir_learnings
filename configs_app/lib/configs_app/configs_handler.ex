defmodule ConfigsApp.ConfigsHandler do
  require Config

  def get_configs() do
    # Config.config_env() |> inspect()
    Application.fetch_env!(:configs_app, :addresses)
  end
end
