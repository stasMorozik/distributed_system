defmodule Shop.OwnerProductSchema do
  use Ecto.Schema
  import Ecto.Changeset

  alias Shop.OwnerSchema
  alias Shop.ProductSchema

  @primary_key :false
  @foreign_key_type :binary_id
  schema "owner_products" do
    belongs_to :owners, OwnerSchema, foreign_key: :owner_id
    belongs_to :products, ProductSchema, foreign_key: :product_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:product_id, :owner_id])
    |> validate_required([:product_id, :owner_id])
    |> unique_constraint(:product_id, name: :owner_products_product_id_index)
  end
end
