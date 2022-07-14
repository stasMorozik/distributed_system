defmodule Core.DomainLayer.Ports.DeletingProductLikePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleDeleteError

  alias Core.DomainLayer.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleDeleteError.t()}

  @callback delete(Id.t()) :: ok() | error()
end
