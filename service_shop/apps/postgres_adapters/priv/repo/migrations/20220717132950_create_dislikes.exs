defmodule Shop.Repo.Migrations.CreateDislikes do
  use Ecto.Migration

  def change do
    create table(:dislikes) do
      add :owner_id, references(:owners, type: :uuid, on_delete: :delete_all), null: false
      add :product_id, references(:products, type: :uuid, on_delete: :delete_all), null: false
    end

    create unique_index(:dislikes, [:owner_id])
  end
end
