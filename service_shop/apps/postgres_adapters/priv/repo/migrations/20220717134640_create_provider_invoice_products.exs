defmodule Shop.Repo.Migrations.CreateProviderInvoiceProducts do
  use Ecto.Migration

  def change do
    create table(:provider_invoice_products) do
      add :invoice_id, references(:provider_invoices, type: :uuid, on_delete: :delete_all), null: false
      add :product_id, references(:products, type: :uuid, on_delete: :delete_all), null: false
    end
  end
end
