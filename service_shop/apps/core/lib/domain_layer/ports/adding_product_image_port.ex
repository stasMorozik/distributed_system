defmodule Core.DomainLayer.Ports.AddingProductImagePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.ImageEntity

  alias Core.DomainLayer.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleCreateError.t()}

  @callback add(Id.t(), list(ImageEntity.t())) :: ok() | error()
end
