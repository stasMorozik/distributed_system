defmodule UserLoggerServiceTest do
  use ExUnit.Case
  doctest UserLoggerService

  test "greets the world" do
    assert UserLoggerService.hello() == :world
  end
end
