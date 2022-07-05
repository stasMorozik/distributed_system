defmodule TaskAdaptersForUserServiceTest do
  use ExUnit.Case
  doctest TaskAdaptersForUserService

  test "greets the world" do
    assert TaskAdaptersForUserService.hello() == :world
  end
end
