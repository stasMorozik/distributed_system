defmodule GettingAdapter do
  @moduledoc false

  import Ecto.Query
  alias Buyers.Repo

  alias Core.DomainLayer.Ports.GettingPort

  alias Core.DomainLayer.BuyerEntity

  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Password

  alias Buyers.BuyersSchema

  @behaviour GettingPort

  @spec get(Id.t()) :: GettingPort.ok() | GettingPort.error()
  def get(%Id{value: id}) do
    query =
      from(b in BuyersSchema,
        where: b.id == ^id
      )

    case Repo.one(query) do
      nil ->
        {:error, NotFoundError.new()}

      buyer ->
        {
          :ok,
          %BuyerEntity{
            email: %Email{value: buyer.email},
            password: %Password{value: buyer.password},
            created: %Created{value: buyer.created},
            id: %Id{value: buyer.id}
          }
        }
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end
end
