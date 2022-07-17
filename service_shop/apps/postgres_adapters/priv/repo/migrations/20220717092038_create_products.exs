defmodule Shop.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :name, :string, null: false
      add :created, :utc_datetime, null: false
      add :amount, :integer, null: false
      add :ordered, :integer, null: false
      add :description, :string, null: false
      add :price, :float, null: false
    end
  end
end
