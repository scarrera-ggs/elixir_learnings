defmodule Identicon.Image do
  @moduledoc """
  struct are maps with some benefits:
  can define default values and enforces then
  map structure defined in the struct
  """
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end
