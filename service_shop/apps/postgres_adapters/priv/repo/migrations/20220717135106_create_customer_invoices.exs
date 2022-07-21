defmodule Shop.Repo.Migrations.CreateCustomerInvoices do
  use Ecto.Migration

  def change do
    create table(:customer_invoices, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :created, :utc_datetime, null: false
      add :price, :float, null: false
      add :number, :integer, null: false
    end
  end
end
