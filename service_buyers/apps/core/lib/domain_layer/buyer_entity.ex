defmodule Core.DomainLayer.BuyerEntity do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Password

  alias Core.DomainLayer.Errors.DomainError
  alias Core.DomainLayer.BuyerEntity

  defstruct email: nil, password: nil, created: nil, id: nil

  @type t :: %BuyerEntity{
          email: Email.t(),
          password: Password.t(),
          id: Id.t(),
          created: Created.t()
        }

  @type ok :: {
          :ok,
          BuyerEntity.t()
        }

  @type error :: {:error, DomainError.t()}

  @type creating_dto ::
          %{
            email: binary(),
            password: binary()
          }

  @type updating_dto ::
          %{
            email: any(),
            password: any(),
          }

  @spec new(creating_dto()) :: ok() | error()
  def new(dto = %{}) when is_map(dto) and map_size(dto) > 0 and is_struct(dto) == false do
    with {:ok, value_email} <- Email.new(dto[:email]),
         {:ok, value_password} <- Password.new(dto[:password]) do
      {
        :ok,
        %BuyerEntity{
          email: value_email,
          password: value_password,
          id: Id.new(),
          created: Created.new()
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(_) do
    {:error, DomainError.new("Invalid input data")}
  end

  @spec validate_password(BuyerEntity.t(), binary()) :: {:ok, true} | error()
  def validate_password(%BuyerEntity{} = entity, password)
      when is_struct(entity) and is_binary(password) do
    with true <- is_binary(password),
         true <- Bcrypt.verify_pass(password, entity.password.value) do
      {:ok, true}
    else
      false -> {:error, DomainError.new("Wrong password")}
    end
  end

  def validate_password(_, _) do
    {:error, DomainError.new("Invalid input data")}
  end

  @spec update(BuyerEntity.t(), updating_dto()) :: ok() | error()
  def update(%BuyerEntity{} = entity, %{} = dto)
      when is_map(dto) and is_struct(dto) == false and map_size(dto) > 0 and is_struct(entity) do
    case is_empty(dto) do
      true -> {:error, DomainError.new("Invalid input data")}
      false ->
        update_email({:ok, entity}, dto) |> update_password(dto)
    end
  end

  def update(_, _) do
    {:error, DomainError.new("Invalid input data")}
  end

  defp update_email({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:email] != nil,
         {:ok, value_email} <- Email.new(dto[:email]) do
      {:ok, %BuyerEntity{maybe_entity | email: value_email}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_password({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:password] != nil,
         {:ok, value_password} <- Password.new(dto[:password]) do
      {:ok, %BuyerEntity{maybe_entity | password: value_password}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp is_empty(%{} = dto) do
    cond do
      Map.has_key?(dto, :email) == true -> false
      Map.has_key?(dto, :password) == true -> false
      true -> true
    end
  end
end
