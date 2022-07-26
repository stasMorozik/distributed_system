defmodule UpdatingAdapter do
  @moduledoc false

  alias Buyers.Repo

  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.BuyerEntity

  alias Core.DomainLayer.Dtos.AlreadyExistsError
  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

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
      {:ok, _} -> {:ok, true}
      _ -> {:error, AlreadyExistsError.new()}
    end
  end

  def update(_) do
    {:error, ImpossibleUpdateError.new()}
  end
end
