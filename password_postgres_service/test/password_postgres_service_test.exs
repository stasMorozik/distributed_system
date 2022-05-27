defmodule PasswordPostgresServiceTest do
  use ExUnit.Case
  doctest PasswordPostgresService

  test "greets the world" do
    assert PasswordPostgresService.hello() == :world
  end
end
