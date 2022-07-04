defmodule CodesSchema do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "users" do
    field :email, :string
    field :code, :integer
    field :created, :utc_datetime
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:email, :code, :created, :id])
    |> validate_required([:email, :code, :created, :id])
    |> unique_constraint(:email, name: :codes_email_index)
    |> unique_constraint(:id, name: :codes_pkey)
  end

  def update_changeset(data, params \\ %{}) do
    data
    |> cast(params, [:code, :created,])
    |> validate_required([:code, :created,])
  end
end
