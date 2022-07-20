defmodule Shop.CustomerInvoiceProviderInvoiceSchema do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Shop.CustomerInvoiceSchema
  alias Shop.ProviderInvoiceSchema

  @foreign_key_type :binary_id
  schema "customer_invoice_invoices" do
    belongs_to :customer_invoice, CustomerInvoiceSchema, foreign_key: :customer_invoice_id
    belongs_to :provider_invoice, ProviderInvoiceSchema, foreign_key: :provider_invoice_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:customer_invoice_id, :provider_invoice_id])
    |> validate_required([:customer_invoice_id, :provider_invoice_id])
    |> unique_constraint(:provider_invoice_id, name: :customer_invoice_invoices_provider_invoice_id_index)
  end
end
