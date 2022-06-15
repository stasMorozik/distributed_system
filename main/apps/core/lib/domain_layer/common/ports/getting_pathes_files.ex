defmodule Core.DomainLayer.Common.Ports.GettingPathesFiles do
  @type t :: module

  @callback get(nonempty_list(binary())) :: list(binary())
end
