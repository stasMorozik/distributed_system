defmodule Shop.Repo.Migrations.CreateProviderInvoices do
  use Ecto.Migration

  def change do
    create table(:provider_invoices, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :created, :utc_datetime, null: false
      add :price, :float, null: false
      add :number, :string, null: false
      add :status, :string, null: false
    end
  end
end
