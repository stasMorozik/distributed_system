defmodule Core.DomainLayer.Domains.Product.UseCases.UpdatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Product.ProductEntity

  alias Core.DomainLayer.Domains.Product.Dtos.UpdatingData

  alias Core.DomainLayer.Domains.Product.Ports.UpdatingPort

  @type t :: Module

  @type ok :: {:ok, ProductEntity.t()}
end
