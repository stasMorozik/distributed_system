defmodule CreatingAdapter do
  @moduledoc false

  alias Buyers.Repo

  alias Core.DomainLayer.Ports.CreatingPort

  alias Core.DomainLayer.Errors.InfrastructureError

  alias Core.DomainLayer.BuyerEntity

  alias Buyers.BuyersSchema

  @behaviour CreatingPort

  @spec create(BuyerEntity.t()) :: CreatingPort.ok() | CreatingPort.error()
  def create(%BuyerEntity{} = entity) do
    buyer_changeset = %BuyersSchema{} |> BuyersSchema.changeset(%{
      email: entity.email.value,
      password: entity.password.value,
      created: entity.created.value,
      id: entity.id.value
    })

    case Repo.transaction(fn ->
      Repo.insert(:buyers, buyer_changeset)
    end) do
      {:ok, _} ->
        {:ok, true}

      error ->
        with {:error, _, error_changeset, _} <- error,
             [head| _] <- error_changeset.errors,
             {:email, {"has already been taken", _}} <- head do
          {:error, InfrastructureError.new("User with this email already exists")}
        else
          _ -> {:error, InfrastructureError.new("Something went wrong")}
        end
    end
  end

  def create(_) do
    {:error, InfrastructureError.new("Invalid input data for inserting")}
  end
end
