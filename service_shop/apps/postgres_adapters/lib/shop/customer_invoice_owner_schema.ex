defmodule Shop.CustomerInvoiceOwnerSchema do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Shop.OwnerSchema
  alias Shop.CustomerInvoiceSchema

  @foreign_key_type :binary_id
  schema "customer_invoices_owners" do
    belongs_to :customer, OwnerSchema, foreign_key: :customer_id
    belongs_to :ivnoice, CustomerInvoiceSchema, foreign_key: :invoice_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:customer_id, :invoice_id])
    |> validate_required([:customer_id, :invoice_id])
    |> unique_constraint(:invoice_id, name: :customer_invoices_owners_invoice_id_index)
  end
end
