defmodule Shop.ProviderInvoiceProductShema do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Shop.ProductSchema
  alias Shop.ProviderInvoiceSchema

  @foreign_key_type :binary_id
  schema "provider_invoice_products" do
    field :amount, :integer
    belongs_to :invoice, ProviderInvoiceSchema, foreign_key: :invoice_id
    belongs_to :product, ProductSchema, foreign_key: :product_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:invoice_id, :product_id, :amount])
    |> validate_required([:invoice_id, :product_id, :amount])
  end
end
