defmodule Shop.ImageShema do
  use Ecto.Schema
  import Ecto.Changeset

  alias Shop.ProductSchema

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "images" do
    field :image, :string
    field :created, :utc_datetime
    belongs_to :product, ProductSchema, foreign_key: :product_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:image, :created, :id, :product_id])
    |> validate_required([:image, :created, :id, :product_id])
    |> unique_constraint(:id, name: :images_pkey)
  end
end
