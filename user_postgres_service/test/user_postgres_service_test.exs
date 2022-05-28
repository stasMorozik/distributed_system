defmodule UserPostgresServiceTest do
  use ExUnit.Case
  doctest UserPostgresService

  test "greets the world" do
    assert UserPostgresService.hello() == :world
  end
end
