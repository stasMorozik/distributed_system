defmodule UserControllerTest do
  use ExUnit.Case
  doctest UserController

  test "greets the world" do
    assert UserController.hello() == :world
  end
end
