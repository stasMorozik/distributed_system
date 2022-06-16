defmodule Core.DomainLayer.Common.Ports.GettingPathesFiles do
  @moduledoc false

  @type t :: module

  @callback get(nonempty_list(binary())) :: list(binary())
end
