defmodule Core.CoreDomains.Common.Ports.Notifying do
  @type t :: module

  @callback notify(binary) :: any()
end
