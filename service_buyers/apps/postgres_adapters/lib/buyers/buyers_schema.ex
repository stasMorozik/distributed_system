defmodule Buyers.BuyersSchema do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "buyers" do
    field :email, :string
    field :password, :string
    field :created, :utc_datetime
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:email, :password, :created, :id])
    |> validate_required([:email, :password, :created, :id])
    |> unique_constraint(:email, name: :buyers_email_index)
    |> unique_constraint(:id, name: :buyers_pkey)
  end

  def update_changeset(data, params \\ %{}) do
    data
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email, name: :buyers_email_index)
  end
end
