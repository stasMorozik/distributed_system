defmodule Codes.Repo.Migrations.CreateCodes do
  use Ecto.Migration

  def change do
    create table(:codes, primary_key: false) do
      add :code, :integer, null: false
      add :email, :string, null: false
      add :id, :uuid, primary_key: true, null: false
      add :created, :utc_datetime, null: false
    end

    create unique_index(:codes, [:email])
  end
end
