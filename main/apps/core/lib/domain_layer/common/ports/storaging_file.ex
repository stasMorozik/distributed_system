defmodule Core.DomainLayer.Common.Ports.StoragingFile do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError

  @type t :: module

  @type ok :: {:ok, binary()}
  @type error :: {:error, ImpossibleCreateError.t()}

  @callback storage(binary()) :: ok() | error()
end
