defmodule Core.DomainLayer.Domains.Shop.Ports.UpdatingPort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Common.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Common.Dtos.ImpossibleCallError
  alias Core.DomainLayer.Common.Dtos.AlreadyExistsError

  alias Core.DomainLayer.Common.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {
          :error,
          ImpossibleUpdateError.t()
          | IdIsInvalidError.t()
          | ImpossibleCallError.t()
          | AlreadyExistsError.t()
        }

  @callback create(Id.t(), UpdatingData.t()) :: ok() | error()
end
