defmodule UpdatingAdapter do
  @moduledoc false

  alias Buyers.Repo

  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.BuyerEntity

  alias Core.DomainLayer.Errors.InfrastructureError

  alias Buyers.BuyersSchema

  @behaviour UpdatingPort

  @spec update(BuyerEntity.t()) :: UpdatingPort.ok() | UpdatingPort.error()
  def update(%BuyerEntity{} = entity) do

    buyer_changeset = %BuyersSchema{id: entity.id.value} |> BuyersSchema.update_changeset(%{
      email: entity.email.value,
      password: entity.password.value
    })

    case Repo.transaction(fn ->
      Repo.update(:buyers, buyer_changeset)
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

  def update(_) do
    {:error, InfrastructureError.new("Invalid input data for updating")}
  end
end
