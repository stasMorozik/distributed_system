defmodule Shop.Repo.Migrations.AlterCustomerInvoiceInvoices do
  use Ecto.Migration

  def change do
    create unique_index(:customer_invoice_invoices, [:provider_invoice_id])
  end
end
