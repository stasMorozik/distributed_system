defmodule CreatingAdapter do
  @moduledoc false

  alias Buyers.Repo

  alias Core.DomainLayer.Ports.CreatingPort

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.AlreadyExistsError

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
      {:ok, _} -> {:ok, true}
      _ -> {:error, AlreadyExistsError.new()}
    end
  end

  def create(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
