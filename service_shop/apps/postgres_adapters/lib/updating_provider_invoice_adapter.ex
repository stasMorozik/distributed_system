defmodule UpdatingProviderInvoiceAdapter do
  @moduledoc false

  alias Shop.Repo

  alias Core.DomainLayer.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.ProviderInvoiceAggregate
  alias Core.DomainLayer.Ports.UpdatingProviderInvoicePort

  alias alias Shop.ProviderInvoiceSchema

  @behaviour UpdatingProviderInvoicePort

  @spec update(ProviderInvoiceAggregate.t()) :: UpdatingProviderInvoicePort.ok() | UpdatingProviderInvoicePort.error()
  def update(%ProviderInvoiceAggregate{} = entity) do
    changeset_product = %ProviderInvoiceSchema{id: entity.id.value} |> ProviderInvoiceSchema.update_changeset(%{
      status: entity.status.value
    })

    case Repo.transaction(fn ->
      Repo.update(changeset_product)
    end)  do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, ImpossibleUpdateError.new()}
    end
  end

  def update(_) do
    {:error, ImpossibleUpdateError.new()}
  end
end
