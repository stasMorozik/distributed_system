defmodule UpdatingAdapter do
  @moduledoc false

  alias Ecto.Multi
  alias Codes.Repo

  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.Errors.InfrastructureError

  alias Core.DomainLayer.ConfirmingCodeEntity

  alias Codes.CodesSchema

  @behaviour UpdatingPort

  @spec update(ConfirmingCodeEntity.t()) :: UpdatingPort.ok() | UpdatingPort.error()
  def update(%ConfirmingCodeEntity{} = entity) do
    changeset_code =
      %CodesSchema{id: entity.id.value}
      |> CodesSchema.update_changeset(%{code: entity.code.value, created: entity.created.value})

    case Multi.new()
         |> Multi.update(:users, changeset_code)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, InfrastructureError.new("Code already exists")}
    end
  end

  def update(_) do
    {:error, InfrastructureError.new("Invalid input data for updating")}
  end
end
