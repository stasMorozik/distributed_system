defmodule GettingProviderInvoiceAdapter do
  @moduledoc false

  import Ecto.Query
  alias Shop.Repo

  alias Core.DomainLayer.Ports.GettingProviderInvoicePort
  alias Core.DomainLayer.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ProviderInvoiceAggregate

  alias Shop.ProviderInvoiceSchema
  alias Shop.ProviderInvoiceOwnerSchema
  alias Shop.ProviderInvoiceProductShema
  alias Shop.OwnerSchema
  alias Shop.ProductSchema
  alias Shop.LogoSchema
  alias Shop.LikeSchema
  alias Shop.DislikeSchema

  @behaviour GettingProviderInvoicePort


  @spec get(Id.t()) :: GettingProviderInvoicePort.ok() | GettingProviderInvoicePort.error()
  def get(%Id{value: id}) do
    with query <-
      from(invoice in ProviderInvoiceSchema, as: :invoice,
        join: owners in ProviderInvoiceOwnerSchema,
        on: owners.invoice_id == invoice.id,
        join: customer in OwnerSchema,
        on: owners.customer_id == customer.id,

        join: provider in OwnerSchema,
        on: owners.provider_id == provider.id,

        join: provider_product in ProviderInvoiceProductShema,
        on: provider_product.invoice_id == invoice.id,
        join: product in ProductSchema,
        on: provider_product.product_id == product.id,

        left_join: logo in LogoSchema,
        on: logo.product_id == product.id,

        left_join: like in LikeSchema,
        on: like.product_id == product.id,
        left_join: true_like in OwnerSchema,
        on: like.owner_id == true_like.id,

        left_join: dislike in DislikeSchema,
        on: dislike.product_id == product.id,
        left_join: true_dislike in OwnerSchema,
        on: dislike.owner_id == true_dislike.id,

        where: invoice.id == ^id,
        preload: [
          customer: customer,
          provider: provider,
          products: {product, likes: true_like, dislikes: true_dislike, logo: logo}
        ],
        select: {
          invoice,
          %{count: fragment("count(?) as like_count", true_like)},
          %{count: fragment("count(?) as dislike_count", true_dislike)}
        },
        group_by: [invoice.id, true_dislike.id, true_like.id, logo.id, product.id, provider.id, customer.id],
      ),
      lsit <- Repo.one(query) do
        lsit
    else
      false -> {:error, NotFoundError.new("Provider invoice")}
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end
end
