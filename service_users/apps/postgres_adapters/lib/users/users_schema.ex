defmodule Users.UsersSchema do
  use Ecto.Schema
  import Ecto.Changeset

  alias Users.AvatarsSchema

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "users" do
    field :name, :string
    field :surname, :string
    field :email, :string
    field :phone, :string
    field :password, :string
    field :created, :utc_datetime
    has_one :avatar, AvatarsSchema, foreign_key: :user_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:name, :surname, :email, :phone, :password, :created, :id])
    |> cast_assoc(:avatar, required: true)
    |> validate_required([:name, :surname, :email, :phone, :password, :created, :id])
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:phone, name: :users_phone_index)
    |> unique_constraint(:id, name: :users_pkey)
  end

  def update_changeset(data, params \\ %{}) do
    data
    |> cast(params, [:name, :surname, :email, :phone, :password])
    |> validate_required([:name, :surname, :email, :phone, :password])
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:phone, name: :users_phone_index)
  end
end
