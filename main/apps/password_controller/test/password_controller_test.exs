defmodule PasswordControllerTest do
  use ExUnit.Case
  doctest PasswordController

  test "greets the world" do
    assert PasswordController.hello() == :world
  end
end
