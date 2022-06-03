defmodule NotifyingMailerServiceTest do
  use ExUnit.Case
  doctest NotifyingMailerService

  test "greets the world" do
    assert NotifyingMailerService.hello() == :world
  end
end
