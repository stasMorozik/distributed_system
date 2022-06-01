defmodule UserPostgresService.PersonsScheme do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "persons" do
    field :name, :string
    field :created, :utc_datetime
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:id, :name, :created])
    |> validate_required([:id, :name, :created])
    |> unique_constraint(:id, name: :persons_pkey)
  end
end