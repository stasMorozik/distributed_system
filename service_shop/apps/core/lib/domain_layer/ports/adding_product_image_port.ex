defmodule Core.DomainLayer.Ports.AddingProductImagePort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.ImageEntity

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleCreateError.t()}

  @callback add(list(ImageEntity.t())) :: ok() | error()
end
