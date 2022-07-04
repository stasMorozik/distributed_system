defmodule PostgresAdapters do
  @moduledoc false

  alias Ecto.Multi
  import Ecto.Query
  alias Codes.Repo

  alias Codes.CodesSchema

  alias Core.DomainLayer.Ports.CreatingPort
  alias Core.DomainLayer.Ports.GettingPort
  alias Core.DomainLayer.Ports.UpdatingPort
  alias Core.DomainLayer.Ports.DeletingPort

  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Code

  alias Core.DomainLayer.Dtos.AlreadyExistsError
  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.ImpossibleGetError
  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.Dtos.ImpossibleDeleteError

  alias Core.DomainLayer.ConfirmingCodeEntity

  @behaviour CreatingPort
  @behaviour GettingPort
  @behaviour UpdatingPort

  @spec create(ConfirmingCodeEntity.t()) :: CreatingPort.ok() | CreatingPort.error()
  def create(%ConfirmingCodeEntity{
        id: %Id{value: id},
        email: %Email{value: email},
        code: %Code{value: code},
        created: %Created{value: created}
      }) do
    is_date_time = fn
      %DateTime{} = _ -> true
      _ -> false
    end

    with true <- is_binary(id),
         true <- is_binary(email),
         true <- is_integer(code),
         true <- is_struct(created),
         {:ok, _} <- UUID.info(id),
         true <- is_date_time.(created) do
      _create(%{
        id: id,
        email: email,
        code: code,
        created: created
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
    q = from(c in CodesSchema, where: c.email == ^schema.email)

    changeset_code = %CodesSchema{} |> CodesSchema.changeset(schema)

    case Multi.new()
         |> Multi.delete_all(:delete_code, q)
         |> Multi.insert(:codes, changeset_code)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      _ -> {:error, AlreadyExistsError.new()}
    end
  end

  @callback get(Email.t()) :: GettingPort.ok() | GettingPort.error()
  def get(%Email{value: email}) when is_binary(email) do
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

  @spec update(ConfirmingCodeEntity.t()) :: UpdatingPort.ok() | UpdatingPort.error()
  def update(%ConfirmingCodeEntity{
        id: %Id{value: id},
        email: %Email{value: email},
        code: %Code{value: code},
        created: %Created{value: created}
      }) do
    is_date_time = fn
      %DateTime{} = _ -> true
      _ -> false
    end

    with true <- is_binary(id),
         true <- is_binary(email),
         true <- is_integer(code),
         true <- is_struct(created),
         {:ok, _} <- UUID.info(id),
         true <- is_date_time.(created) do
      _update(%{
        id: id,
        email: email,
        code: code,
        created: created
      })
    else
      false -> {:error, ImpossibleCreateError.new()}
      {:ok, _} -> {:error, ImpossibleCreateError.new()}
    end
  end

  def update(_) do
    {:error, ImpossibleCreateError.new()}
  end

  defp _update(schema) do
    changeset_code =
      %CodesSchema{id: schema.id}
      |> CodesSchema.update_changeset(%{code: schema.code, created: schema.created})

    case Multi.new()
         |> Multi.update(:users, changeset_code)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      {:error, _} -> {:error, AlreadyExistsError.new()}
    end
  end

  @spec delete(Email.t()) :: DeletingPort.ok() | DeletingPort.error()
  def delete(%Email{value: email}) when is_binary(email) do
    q = from(c in CodesSchema, where: c.email == ^email)

    case Multi.new()
         |> Multi.delete_all(:delete_code, q)
         |> Repo.transaction() do
      {:ok, _} -> {:ok, true}
      _ -> {:error, NotFoundError.new()}
    end
  end

  def delete(_) do
    {:error, ImpossibleDeleteError.new()}
  end
end
