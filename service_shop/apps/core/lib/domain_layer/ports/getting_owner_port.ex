defmodule Core.DomainLayer.Ports.GettingOwnerPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.OwnerEntity

  @type t :: Module

  @type ok :: {:ok, OwnerEntity.t()}

  @type error :: {:error, NotFoundError.t() | ImpossibleGetError.t()}

  @callback get(Id.t()) :: ok() | error()
end
