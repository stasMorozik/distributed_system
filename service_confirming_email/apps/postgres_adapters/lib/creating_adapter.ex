defmodule CreatingAdapter do
  @moduledoc false

  alias Ecto.Multi
  import Ecto.Query
  alias Codes.Repo

  alias Core.DomainLayer.Ports.CreatingPort
  alias Core.DomainLayer.ConfirmingCodeEntity

  alias Core.DomainLayer.Errors.InfrastructureError

  alias Codes.CodesSchema

  @behaviour CreatingPort

  @spec create(ConfirmingCodeEntity.t()) :: CreatingPort.ok() | CreatingPort.error()
  def create(%ConfirmingCodeEntity{} = entity) do
    q = from(c in CodesSchema, where: c.email == ^entity.email.value)

    changeset_code = %CodesSchema{} |> CodesSchema.changeset(%{
      id: entity.id.value,
      email: entity.email.value,
      code: entity.code.value,
      created: entity.created.value
    })

    case Multi.new()
         |> Multi.delete_all(:delete_code, q)
         |> Multi.insert(:codes, changeset_code)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      _ -> {:error, InfrastructureError.new("Code already exists")}
    end
  end

  def create(_) do
    {:error, InfrastructureError.new("Invalid input data for inserting")}
  end
end
