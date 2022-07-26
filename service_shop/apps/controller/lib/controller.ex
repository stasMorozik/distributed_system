defmodule Controller do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Sorting
  alias Core.DomainLayer.ValueObjects.Splitting
  alias Core.DomainLayer.ValueObjects.Pagination

  alias Core.DomainLayer.UseCases.AddingProductImageUseCase
  alias Core.ApplicationLayer.AddingProductImageService
  alias AddingProductImageAdapter

  alias Core.DomainLayer.UseCases.CreatingCustomerInvoiceUseCase
  alias Core.ApplicationLayer.CreatingCustomerInvoiceService
  alias GettingProductAdapterimple
  alias CreatingCustomerInvoiceAdapter

  alias Core.DomainLayer.UseCases.CreatingProductUseCase
  alias Core.ApplicationLayer.CreatingProductService
  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.UseCases.DeletingProductImageUseCase
  alias Core.ApplicationLayer.DeletingProductImageService

  alias Core.DomainLayer.UseCases.DislikingProductUseCase
  alias Core.ApplicationLayer.DislikingProductservice
  alias AddingProductDislikeAdapter
  alias DeletingProductDislikeAdapter

  alias Core.DomainLayer.UseCases.GettingCustomerInvoiceUseCase
  alias Core.ApplicationLayer.GettingCustomerInvoiceService
  alias GettingCustomerInvoiceAdapter

  alias Core.DomainLayer.UseCases.GettingListCustomerInvoiceUseCase
  alias Core.ApplicationLayer.GettingListCustomerInvoiceService
  alias GettingListCustomerInvoicesAdapter

  alias Core.DomainLayer.UseCases.GettingListProductUseCase
  alias Core.ApplicationLayer.GettingListProductService
  alias GettingListProductAdapter

  alias Core.DomainLayer.UseCases.GettingListProviderInvoiceUseCase
  alias Core.ApplicationLayer.GettingListProviderInvoiceService
  alias GettingListProviderInvoiceAdapter

  alias Core.DomainLayer.UseCases.GettingProductUseCase
  alias Core.ApplicationLayer.GettingProductService
  alias GettingProductAdapter

  alias Core.DomainLayer.UseCases.GettingProviderInvoiceUseCase
  alias Core.ApplicationLayer.GettingProviderInvoiceService
  alias GettingProviderInvoiceAdapter

  alias Core.DomainLayer.UseCases.LikingProductUseCase
  alias Core.ApplicationLayer.LikingProductservice
  alias AddingProductLikeAdapter
  alias DeletingProductLikeAdapter

  alias Core.DomainLayer.UseCases.UpdatingProductUseCase
  alias Core.ApplicationLayer.UpdatingProductService
  alias UpdatingProductAdapter

  alias Core.DomainLayer.UseCases.UpdatingProviderInvoiceStatusUseCase
  alias Core.ApplicationLayer.UpdatingProviderInvoiceStatusService
  alias UpdatingProviderInvoiceAdapter

  @spec cretae_customer_invoice(
          CreatingCustomerInvoiceUseCase.creating_dto
        ) :: CreatingCustomerInvoiceUseCase.ok() | CreatingCustomerInvoiceUseCase.error()
  def cretae_customer_invoice(creating_dto) do
    CreatingCustomerInvoiceService.create(
      creating_dto,
      GettingProductAdapterimple,
      CreatingCustomerInvoiceAdapter
    )
  end

  @spec get_customer_invoice(
          binary()
        ) :: GettingCustomerInvoiceUseCase.ok() | GettingCustomerInvoiceUseCase.error()
  def get_customer_invoice(maybe_id) do
    GettingCustomerInvoiceService.get(maybe_id, GettingCustomerInvoiceAdapter)
  end

  @spec get_list_customer_invoice(
          Pagination.creating_dto(),
          Sorting.creating_dto()                             | nil,
          GettingListCustomerInvoiceUseCase.dto_filtration() | nil,
          Splitting.creating_dto()                           | nil
        ) :: GettingListCustomerInvoiceUseCase.ok() | GettingListCustomerInvoiceUseCase.error()
  def get_list_customer_invoice(dto_pagination, maybe_dto_sorting, maybe_dto_filtration, maybe_dto_spliting) do
    GettingListCustomerInvoiceService.get(
      dto_pagination,
      maybe_dto_sorting,
      maybe_dto_filtration,
      maybe_dto_spliting,
      GettingListCustomerInvoicesAdapter
    )
  end

  @callback update_provider_invoice_status(
              binary()
            ) :: UpdatingProviderInvoiceStatusUseCase.ok() | UpdatingProviderInvoiceStatusUseCase.error()
  def update_provider_invoice_status(maybe_id) do
    UpdatingProviderInvoiceStatusService.update(
      maybe_id,
      GettingProviderInvoiceAdapter,
      UpdatingProviderInvoiceAdapter
    )
  end

  @spec get_provider_invoice(
          binary()
        ) :: GettingProviderInvoiceUseCase.ok() | GettingProviderInvoiceUseCase.error()
  def get_provider_invoice(maybe_id) do
    GettingProviderInvoiceService.get(maybe_id, GettingProviderInvoiceAdapter)
  end

  @spec get_list_provider_invoice(
              Pagination.creating_dto(),
              Sorting.creating_dto()                             | nil,
              GettingListProviderInvoiceUseCase.dto_filtration() | nil,
              Splitting.creating_dto()                           | nil
            ) :: GettingListProviderInvoiceUseCase.ok() | GettingListProviderInvoiceUseCase.error()
  def get_list_provider_invoice(dto_pagination, maybe_dto_sorting, maybe_dto_filtration, maybe_dto_spliting) do
    GettingListProviderInvoiceService.get(
      dto_pagination,
      maybe_dto_sorting,
      maybe_dto_filtration,
      maybe_dto_spliting,
      GettingListProviderInvoiceAdapter
    )
  end

  @spec create_product(
              ProductAggregate.creating_dto()
            ) :: CreatingProductUseCase.ok() | CreatingProductUseCase.error()
  def create_product(creating_dto) do
    CreatingProductService.create(creating_dto, CreatingProductAdapter)
  end

  @spec update_product(
              binary(),
              UpdatingProductUseCase.updating_dto()
            ) :: UpdatingProductUseCase.ok() | UpdatingProductUseCase.error()
  def update_product(maybe_id, updating_dto) do
    UpdatingProductService.update(
      maybe_id,
      updating_dto,
      GettingProductAdapter,
      UpdatingProductAdapter
    )
  end

  @spec add_image_product(binary(), list(binary())) :: AddingProductImageUseCase.ok() | AddingProductImageUseCase.error()
  def add_image_product(maybe_id, list_binary) do
    AddingProductImageService.add(
      maybe_id,
      list_binary,
      GettingProductAdapter,
      AddingProductImageAdapter
    )
  end

  @spec delete_image_product(binary(), binary()) :: DeletingProductImageUseCase.ok() | DeletingProductImageUseCase.error()
  def delete_image_product(maybe_product_id, maybe_image_id) do
    DeletingProductImageService.delete(
      maybe_product_id,
      maybe_image_id,
      GettingProductAdapter,
      DeletingImageProductAdapter
    )
  end

  @spec dislike_product(
          binary(), DislikingProductUseCase.owner_dto()
        ) :: DislikingProductUseCase.ok() | DislikingProductUseCase.error()
  def dislike_product(maybe_id, owner_dto) do
    DislikingProductservice.dislike(
      maybe_id,
      owner_dto,
      GettingProductAdapter,
      AddingProductDislikeAdapter,
      DeletingProductDislikeAdapter
    )
  end

  @spec like_product(
              binary(),
              LikingProductUseCase.owner_dto()
            ) :: LikingProductUseCase.ok() | LikingProductUseCase.error()
  def like_product(maybe_id, owner_dto) do
    LikingProductservice.like(
      maybe_id,
      owner_dto,
      GettingProductAdapter,
      AddingProductLikeAdapter,
      DeletingProductLikeAdapter
    )
  end

  @spec get_product(binary()) :: GettingProductUseCase.ok() | GettingProductUseCase.error()
  def get_product(maybe_id) do
    GettingProductService.get(maybe_id, GettingProductAdapter)
  end

  @spec get_list_product(
              Pagination.creating_dto(),
              Sorting.creating_dto()                     | nil,
              GettingListProductUseCase.dto_filtration() | nil,
              Splitting.creating_dto()                   | nil
            ) :: GettingListProductUseCase.ok() | GettingListProductUseCase.error()
  def get_list_product(dto_pagination, maybe_dto_sorting, maybe_dto_filtration, maybe_dto_spliting) do
    GettingListProductService.get(
      dto_pagination,
      maybe_dto_sorting,
      maybe_dto_filtration,
      maybe_dto_spliting,
      GettingListProductAdapter
    )
  end
end
