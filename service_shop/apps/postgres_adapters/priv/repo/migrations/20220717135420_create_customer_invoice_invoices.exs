defmodule Shop.Repo.Migrations.CreateCustomerInvoiceInvoices do
  use Ecto.Migration

  def change do
    create table(:customer_invoice_invoices, primary_key: false) do
      add :customer_invoice_id, references(:customer_invoices, type: :uuid, on_delete: :delete_all), null: false
      add :provider_invoice_id, references(:provider_invoices, type: :uuid, on_delete: :delete_all), null: false
    end
  end
end
