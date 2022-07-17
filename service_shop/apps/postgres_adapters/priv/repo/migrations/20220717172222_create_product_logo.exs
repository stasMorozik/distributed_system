defmodule Shop.Repo.Migrations.CreateProductLogo do
  use Ecto.Migration

  def change do
    create table(:logos, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :created, :utc_datetime, null: false
      add :image, :bytea, null: false
      add :product_id, references(:products, type: :uuid, on_delete: :delete_all), null: false
    end
  end
end
