defmodule Users.AvatarsSchema do
  use Ecto.Schema
  import Ecto.Changeset

  alias Users.UsersSchema

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "avatars" do
    field :image, :string
    field :created, :utc_datetime
    belongs_to :user, UsersSchema, foreign_key: :user_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:image, :created, :id])
    |> validate_required([:image, :created, :id])
    |> unique_constraint(:id, name: :avatars_pkey)
  end
end
