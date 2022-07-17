defmodule Shop.ProductSchema do
  use Ecto.Schema
  import Ecto.Changeset

  alias Shop.OwnerProductsSchema

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "products" do
    field :name, :string
    field :created, :utc_datetime
    field :amount, :integer
    field :ordered, :integer
    field :description, :string
    field :price, :float
    has_one :owner, OwnerProductsSchema, foreign_key: :product_id
    #has many images
    #has one logo
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:name, :created, :amount, :ordered, :description, :price, :id])
    |> validate_required([:name, :created, :amount, :ordered, :description, :price, :id])
    |> unique_constraint(:id, name: :products_pkey)
  end
end
