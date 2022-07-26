defmodule GetingAdapter do
  @moduledoc false

  import Ecto.Query
  alias Codes.Repo

  alias Core.DomainLayer.Ports.GettingPort

  alias Core.DomainLayer.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Dtos.NotFoundError

  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Code

  alias Core.DomainLayer.ConfirmingCodeEntity

  alias Codes.CodesSchema

  @behaviour GettingPort

  @spec get(Email.t()) :: GettingPort.ok() | GettingPort.error()
  def get(%Email{value: email}) do
    query = from(c in CodesSchema, where: c.email == ^email)

    case Repo.one(query) do
      nil ->
        {:error, NotFoundError.new()}

      code ->
        {
          :ok,
          %ConfirmingCodeEntity{
            id: %Id{value: code.id},
            email: %Email{value: code.email},
            code: %Code{value: code.code},
            created: %Created{value: code.created}
          }
        }
    end
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end
end
