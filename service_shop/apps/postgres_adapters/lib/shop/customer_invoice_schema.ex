defmodule Shop.CustomerInvoiceSchema do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Shop.CustomerInvoiceOwnerSchema
  alias Shop.CustomerInvoiceProviderInvoiceSchema

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "customer_invoices" do
    field :created, :utc_datetime
    field :number, :string
    field :price, :float
    has_one :customer, CustomerInvoiceOwnerSchema, foreign_key: :invoice_id
    has_many :provider_invoces, CustomerInvoiceProviderInvoiceSchema, foreign_key: :customer_invoice_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:number, :created, :price, :id])
    |> validate_required([:number, :created, :price, :id])
    |> unique_constraint(:id, name: :customer_invoices_pkey)
  end
end
