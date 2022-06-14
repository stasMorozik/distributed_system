defmodule UserPasswordPostgresServiceTest do
  use ExUnit.Case
  doctest UserPasswordPostgresService

  test "greets the world" do
    assert UserPasswordPostgresService.hello() == :world
  end
end
