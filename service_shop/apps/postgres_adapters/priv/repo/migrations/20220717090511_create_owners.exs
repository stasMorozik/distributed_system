defmodule Shop.Repo.Migrations.CreateOwners do
  use Ecto.Migration

  def change do
    create table(:owners, primary_key: false) do
      add :email, :string, null: false
      add :id, :uuid, primary_key: true, null: false
      add :created, :utc_datetime, null: false
    end

    create unique_index(:owners, [:email])
  end
end
