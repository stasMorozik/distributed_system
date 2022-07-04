defmodule Core.DomainLayer.Ports.UpdatingPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

  alias Core.DomainLayer.ConfirmingCodeEntity

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleUpdateError.t()}

  @callback update(ConfirmingCodeEntity.t()) :: ok() | error()
end
