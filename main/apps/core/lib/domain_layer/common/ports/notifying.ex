defmodule Core.DomainLayer.Common.Ports.Notifying do
  @type t :: module

  @callback notify(binary(), binary(), binary()) :: any()
end
