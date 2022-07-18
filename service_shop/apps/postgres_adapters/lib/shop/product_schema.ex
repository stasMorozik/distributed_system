defmodule Shop.ProductSchema do
  use Ecto.Schema
  import Ecto.Changeset

  alias Shop.OwnerProductSchema
  alias Shop.ImageShema
  alias Shop.LogoSchema

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "products" do
    field :name, :string
    field :created, :utc_datetime
    field :amount, :integer
    field :ordered, :integer
    field :description, :string
    field :price, :float
    has_one :owner, OwnerProductSchema, foreign_key: :product_id
    has_one :logo, LogoSchema, foreign_key: :product_id
    has_many :images, ImageShema, foreign_key: :product_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:name, :created, :amount, :ordered, :description, :price, :id])
    |> cast_assoc(:images, required: true)
    |> cast_assoc(:logo, required: true)
    |> cast_assoc(:owner, required: true)
    |> validate_required([:name, :created, :amount, :ordered, :description, :price, :id])
    |> unique_constraint(:id, name: :products_pkey)
  end
end
