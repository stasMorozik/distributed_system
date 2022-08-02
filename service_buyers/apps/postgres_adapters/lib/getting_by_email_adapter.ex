defmodule GettingByEmailAdapter do
  @moduledoc false

  import Ecto.Query
  alias Buyers.Repo

  alias Core.DomainLayer.Ports.GettingByEmailPort

  alias Core.DomainLayer.BuyerEntity

  alias Core.DomainLayer.Errors.InfrastructureError

  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Password

  alias Buyers.BuyersSchema

  @behaviour GettingByEmailPort

  @spec get_by_email(Email.t()) :: GettingByEmailPort.ok() | GettingByEmailPort.error()
  def get_by_email(%Email{value: email}) do
    query =
      from(b in BuyersSchema,
        where: b.email == ^email
      )

    case Repo.one(query) do
      nil ->
        {:error, InfrastructureError.new("Buyer not found")}

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

  def get_by_email(_) do
    {:error, InfrastructureError.new("Invalid input data for select")}
  end

end
