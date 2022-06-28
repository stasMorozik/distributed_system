defmodule Core.DomainLayer.Domains.Product.UseCases.CreatingUseCase do
  @moduledoc false

  alias Core.DomainLayer.Domains.Product.ProductEntity

  alias Core.DomainLayer.Domains.Product.Dtos.CreatingData

  alias Core.DomainLayer.Domains.Product.Ports.CreatingPort

  alias Core.DomainLayer.Common.Ports.StoragingFile

  @type t :: Module

  @type ok :: {:ok, ProductEntity.t()}

  @type error ::
          ProductEntity.error_creating()
          | CreatingPort.error()

  @callback create(CreatingData.t(), CreatingPort.t(), StoragingFile.t()) :: ok() | error()
end
