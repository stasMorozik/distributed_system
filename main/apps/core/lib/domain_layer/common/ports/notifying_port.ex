defmodule Core.DomainLayer.Common.Ports.NotifyingPort do
  @moduledoc false

  @type t :: module

  @callback notify(binary(), binary(), binary()) :: any()
end
