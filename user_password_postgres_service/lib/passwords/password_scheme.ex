defmodule UserPasswordPostgresService.PasswordScheme do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uid, :binary_id, autogenerate: false}
  schema "passwords" do
    field :password, :string
    field :email, :string
    field :confirmed, :boolean
    field :created, :utc_datetime
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:password, :email, :confirmed, :created, :uid])
    |> validate_required([:password, :email, :confirmed, :created, :uid])
    |> unique_constraint(:email, name: :email_unique_index)
    |> unique_constraint(:uid, name: :passwords_pkey)
  end

  def update_email_changeset(data, params \\ %{}) do
    data
    |> cast(params, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email, name: :email_unique_index)
  end
end
