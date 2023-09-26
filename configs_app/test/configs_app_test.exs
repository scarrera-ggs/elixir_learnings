defmodule ConfigsAppTest do
  use ExUnit.Case
  doctest ConfigsApp

  test "greets the world" do
    assert ConfigsApp.hello() == :world
  end
end
