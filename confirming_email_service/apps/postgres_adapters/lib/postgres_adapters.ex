defmodule PostgresAdapters do
  @moduledoc false

  alias Ecto.Multi
  import Ecto.Query
  alias Ecto.Changeset
  alias Codes.Repo

  alias Core.DomainLayer.Ports.CreatingPort
  alias Core.DomainLayer.Ports.GettingPort
  alias Core.DomainLayer.Ports.UpdatingPort

  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Code

  alias Core.DomainLayer.Dtos.AlreadyExistsError
  alias Core.DomainLayer.Dtos.CodeIsWrongError
  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.CodeIsInvalidError
  alias Core.DomainLayer.Dtos.ImpossibleValidateError

  alias Core.DomainLayer.ConfirmingCodeEntity

  @behaviour CreatingPort
  @behaviour GettingPort
  @behaviour UpdatingPort
  #create(%ConfirmingCodeEntity{id: UUID.uuid4(), code: Code.new(), email: %Email{value: "test@gmail.com", created: Created.new()} })
  # PostgresAdapters.create( %ConfirmingCodeEntity{ id: UUID.uuid4(), code: Code.new(), email: %Email{value: "test@gmail.com"}, created: Created.new()  } )
  @spec create(ConfirmingCodeEntity.t()) :: CreatingPort.ok() | CreatingPort.error()
  def create(%ConfirmingCodeEntity{
    id: %Id{value: id},
    email: %Email{value: email},
    code: %Code{value: code},
    created: %Created{value: created}
  }) do
    with true <- is_binary(id),
         true <- is_binary(email),
         true <- is_integer(code),
         true <- is_struct(created),
         {:ok, _} <- UUID.info(id),
         %DateTime{} <- created do
      {:ok, true}
    else
      false ->
        IO.inspect(false)
        {:error, ImpossibleCreateError.new()}
      {:ok, e} ->
        IO.inspect(e)
        {:error, ImpossibleCreateError.new()}
    end
  end

  def create(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
