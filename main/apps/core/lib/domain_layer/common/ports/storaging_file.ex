defmodule Core.DomainLayer.Common.Ports.StoragingFile do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError

  @type t :: module

  @type data :: %{
    operation_name: binary(),
    id: binary(),
    data: binary()
  }

  @type ok :: {:ok, binary()}
  @type error :: {:error, ImpossibleCreateError.t()}

  @callback storage(list(data())) :: ok() | error()
end
