defmodule Shop.ProviderInvoiceSchema do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Shop.ProviderInvoiceOwnerSchema
  alias Shop.ProviderInvoiceProductShema

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "provider_invoices" do
    field :created, :utc_datetime
    field :number, :integer
    field :price, :float
    field :status, :string
    has_one :owners, ProviderInvoiceOwnerSchema, foreign_key: :invoice_id
    has_many :products, ProviderInvoiceProductShema, foreign_key: :invoice_id
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:number, :created, :price, :id, :status])
    |> validate_required([:number, :created, :price, :id, :status])
    |> unique_constraint(:id, name: :provider_invoices_pkey)
  end
end
