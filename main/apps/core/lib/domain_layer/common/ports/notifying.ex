defmodule Core.DomainLayer.Common.Ports.Notifying do
  @moduledoc false

  @type t :: module

  @callback notify(binary(), binary(), binary()) :: any()
end
