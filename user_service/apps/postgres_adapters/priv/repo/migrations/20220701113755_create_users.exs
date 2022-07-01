defmodule Users.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :name, :string
      add :surname, :string
      add :email, :string
      add :phone, :string
      add :password, :string
      add :id, :uuid, primary_key: true, null: false
      add :created, :utc_datetime
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:phone])
  end
end
