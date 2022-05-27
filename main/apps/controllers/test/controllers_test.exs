defmodule ControllersTest do
  use ExUnit.Case
  doctest Controllers

  test "greets the world" do
    assert Controllers.hello() == :world
  end
end
