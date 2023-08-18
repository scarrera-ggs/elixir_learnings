defmodule Identicon do
  @moduledoc """
    This module generates an identicon. An identicon is a 5x5 grid,
    each tile is 50px, the identicon grid is symmetric meaning that the second half
    is identical from the first half (vertically),
    and the identicon is generate based on a string (seed).
  """
  def main(input) do
    input
      |> hash_input()
      |> pick_color()
      |> build_grid
      |> filter_odd_squares
      |> build_pixel_map
      |> draw_image
      |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    # egd = Erlang Graphical Drawing
    identicon = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {top_left, bottom_right} ->
      :egd.filledRectangle(identicon, top_left, bottom_right, fill)
    end)

    :egd.render(identicon)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map(grid, fn {_code, index} ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn {code, _index} ->
      rem(code, 2) == 0
    end)

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first] # ++ appends a list -> [145, 46, 200, 46 ,145]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
