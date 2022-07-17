defmodule Shop.Repo.Migrations.CreateOwnerProducts do
  use Ecto.Migration

  def change do
    create table(:owner_products, primary_key: false) do
      add :owner_id, references(:owners, type: :uuid, on_delete: :delete_all), null: false
      add :product_id, references(:products, type: :uuid, on_delete: :delete_all), null: false
    end

    create unique_index(:owner_products, [:product_id])
  end
end
