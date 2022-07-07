defmodule PostgresAdapters do
  @moduledoc false

  alias Ecto.Multi
  import Ecto.Query
  alias Buyers.Repo

  alias Core.DomainLayer.Ports.CreatingPort
  alias Core.DomainLayer.Ports.GettingByEmailPort
  alias Core.DomainLayer.Ports.GettingPort
  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.BuyerEntity

  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Password

  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Buyers.BuyersSchema

  @behaviour CreatingPort
  @behaviour GettingByEmailPort
  @behaviour GettingPort
  @behaviour UpdatingPort

  @spec create(BuyerEntity.t()) :: CreatingPort.ok() | CreatingPort.error()
  def create(%BuyerEntity{
        email: %Email{value: email},
        password: %Password{value: password},
        id: %Id{value: id},
        created: %Created{value: created}
      }) do

    is_date_time = fn
      %DateTime{} = _ -> true
      _ -> false
    end

    with true <- is_binary(email),
         true <- is_binary(password),
         true <- is_binary(id),
         true <- is_struct(created),
         true <- is_date_time.(created),
         {:ok, _} <- UUID.info(id) do
      _create(%{
        email: email,
        password: password,
        created: created,
        id: id
      })
    else
      false -> {:error, ImpossibleCreateError.new()}
      {:ok, _} -> {:error, ImpossibleCreateError.new()}
    end
  end

  def create(_) do
    {:error, ImpossibleCreateError.new()}
  end

  defp _create(schema) do
    buyer = %BuyersSchema{} |> BuyersSchema.changeset(schema)

    case Multi.new() |> Multi.insert(:buyers, buyer) |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      _ -> {:error, AlreadyExistsError.new()}
    end
  end

  @spec get_by_email(Email.t()) :: GettingByEmailPort.ok() | GettingByEmailPort.error()
  def get_by_email(%Email{value: email}) when is_binary(email) do
    query =
      from(b in BuyersSchema,
        where: b.email == ^email
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

  def get_by_email(_) do
    {:error, ImpossibleGetError.new()}
  end

  @spec get(Id.t()) :: GettingPort.ok() | GettingPort.error()
  def get(%Id{value: id}) when is_binary(id) do
    case UUID.info(id) do
      {:error, _} ->
        {:error, ImpossibleGetError.new()}

      {:ok, _} ->
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
  end

  def get(_) do
    {:error, ImpossibleGetError.new()}
  end

  @spec update(BuyerEntity.t()) :: UpdatingPort.ok() | UpdatingPort.error()
  def update(%BuyerEntity{
        email: %Email{value: email},
        password: %Password{value: password},
        id: %Id{value: id},
        created: %Created{value: created}
      }) do

    is_date_time = fn
      %DateTime{} = _ -> true
      _ -> false
    end

    with true <- is_binary(email),
         true <- is_binary(password),
         true <- is_binary(id),
         true <- is_struct(created),
         true <- is_date_time.(created),
         {:ok, _} <- UUID.info(id) do
      _update(%{
        email: email,
        password: password,
        created: created,
        id: id,
      })
    else
      false -> {:error, ImpossibleUpdateError.new()}
      {:ok, _} -> {:error, ImpossibleUpdateError.new()}
    end
  end

  def update(_) do
    {:error, ImpossibleUpdateError.new()}
  end

  defp _update(schema) do
    changeset_buyer = %BuyersSchema{id: schema.id} |> BuyersSchema.update_changeset(%{
      email: schema.email,
      password: schema.password,
    })

    case Multi.new()
         |> Multi.update(:buyers, changeset_buyer)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, AlreadyExistsError.new()}
    end
  end
end
