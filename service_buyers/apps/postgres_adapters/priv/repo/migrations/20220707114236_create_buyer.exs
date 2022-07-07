defmodule Buyers.Repo.Migrations.CreateBuyer do
  use Ecto.Migration

  def change do
    create table(:buyers, primary_key: false) do
      add :email, :string, null: false
      add :password, :string, null: false
      add :id, :uuid, primary_key: true, null: false
      add :created, :utc_datetime, null: false
    end

    create unique_index(:buyers, [:email])
  end
end
