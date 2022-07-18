defmodule Shop.Repo.Migrations.CreateCustomerInvoiceOwners do
  use Ecto.Migration

  def change do
    create table(:customer_invoices_owners) do
      add :customer_id, references(:owners, type: :uuid, on_delete: :delete_all), null: false
      add :invoice_id, references(:customer_invoices, type: :uuid, on_delete: :delete_all), null: false
    end

    create unique_index(:customer_invoices_owners, [:invoice_id])
  end
end
