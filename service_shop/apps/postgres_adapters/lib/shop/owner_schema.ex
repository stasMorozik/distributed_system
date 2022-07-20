defmodule Shop.OwnerSchema do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "owners" do
    field :email, :string
    field :created, :utc_datetime
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:email, :created, :id])
    |> validate_required([:email, :created, :id])
    |> unique_constraint(:email, name: :owners_email_index)
    |> unique_constraint(:id, name: :owners_pkey)
  end
end
