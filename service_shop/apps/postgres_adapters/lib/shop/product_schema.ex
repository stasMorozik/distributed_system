defmodule Shop.ProductSchema do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Shop.OwnerProductSchema
  alias Shop.ImageShema
  alias Shop.LogoSchema
  alias Shop.LikeSchema
  alias Shop.DislikeSchema

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
    has_many :likes, LikeSchema, foreign_key: :product_id
    has_many :dislikes, DislikeSchema, foreign_key: :product_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:name, :created, :amount, :ordered, :description, :price, :id])
    |> cast_assoc(:images, required: false)
    |> cast_assoc(:logo, required: true)
    |> cast_assoc(:owner, required: true)
    |> validate_required([:name, :created, :amount, :ordered, :description, :price, :id])
    |> unique_constraint(:id, name: :products_pkey)
  end

  def update_changeset(data, params \\ %{}) do
    data
    |> cast(params, [:name, :amount, :ordered, :description, :price])
    |> validate_required([:name, :amount, :ordered, :description, :price])
  end
end
