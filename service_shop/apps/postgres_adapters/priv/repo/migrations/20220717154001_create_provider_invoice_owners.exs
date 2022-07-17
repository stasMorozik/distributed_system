defmodule Shop.Repo.Migrations.CreateProviderInvoiceOwners do
  use Ecto.Migration

  def change do
    create table(:provider_invoices_owners, primary_key: false) do
      add :provider_id, references(:owners, type: :uuid, on_delete: :delete_all), null: false
      add :customer_id, references(:owners, type: :uuid, on_delete: :delete_all), null: false
      add :invoice_id, references(:provider_invoices, type: :uuid, on_delete: :delete_all), null: false
    end

    create unique_index(:provider_invoices_owners, [:invoice_id])
  end
end
