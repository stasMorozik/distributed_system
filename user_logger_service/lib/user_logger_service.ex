defmodule UserLoggerService do
  def log(some_type, some_remote_node, some_message) do
    IO.inspect(some_type)
    IO.inspect(some_remote_node)
    IO.inspect(some_message)
  end
end
