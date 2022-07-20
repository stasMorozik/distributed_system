defmodule Shop.Repo.Migrations.AlterProviderInvoiceProducts do
  use Ecto.Migration

  def change do
    alter table("provider_invoice_products") do
      add :amount, :integer, null: false
    end
  end
end
