defmodule PasswordPostgresService.ConfirmingDataScheme do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uid, :binary_id, autogenerate: false}
  schema "confirming_data" do
    field :email, :string
    field :code, :integer
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:email, :code, :uid])
    |> validate_required([:email, :code, :uid])
    |> unique_constraint(:email, name: :confirming_data_email_key)
  end
end
