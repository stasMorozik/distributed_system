defmodule Users.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :name, :string, null: false
      add :surname, :string, null: false
      add :email, :string, null: false
      add :phone, :string, null: false
      add :password, :string, null: false
      add :id, :uuid, primary_key: true, null: false
      add :created, :utc_datetime, null: false
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:phone])
  end
end
