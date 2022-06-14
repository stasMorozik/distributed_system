defmodule Core.CoreDomains.Common.Ports.StoragingFile do
  alias Core.CoreDomains.Common.Dtos.ImpossibleCreateError

  @type t :: module

  @type ok :: {:ok, binary()}
  @type error :: {:error, ImpossibleCreateError.t()}

  @callback storage(binary()) :: ok() | error()
end
