defmodule MailerAdaptersTest do
  use ExUnit.Case
  doctest MailerAdapters

  test "greets the world" do
    assert MailerAdapters.hello() == :world
  end
end
