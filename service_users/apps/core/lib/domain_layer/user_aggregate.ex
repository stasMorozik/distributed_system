defmodule Core.DomainLayer.UserAggregate do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.PhoneNumber
  alias Core.DomainLayer.ValueObjects.Name
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Surname
  alias Core.DomainLayer.ValueObjects.Password

  alias Core.DomainLayer.Errors.DomainError

  alias Core.DomainLayer.AvatarEntity

  alias Core.DomainLayer.UserAggregate

  defstruct name: nil,
            surname: nil,
            email: nil,
            phone: nil,
            password: nil,
            avatar: nil,
            id: nil,
            created: nil

  @type t :: %UserAggregate{
          name: Name.t(),
          surname: Surname.t(),
          email: Email.t(),
          phone: PhoneNumber.t(),
          password: Password.t(),
          avatar: AvatarEntity.t(),
          id: Id.t(),
          created: Created.t()
        }

  @type ok :: {
          :ok,
          UserAggregate.t()
        }

  @type error :: {:error, DomainError.t()}

  @type creating_dto ::
          %{
            name: binary(),
            surname: binary(),
            email: binary(),
            phone: binary(),
            password: binary(),
            avatar: binary()
          }

  @type updating_dto ::
          %{
            name: binary() | nil,
            surname: binary() | nil,
            email: binary() | nil,
            phone: binary() | nil,
            password: binary() | nil,
            avatar: binary() | nil
          }

  @spec new(creating_dto()) :: ok() | error()
  def new(dto = %{}) when is_map(dto) and map_size(dto) > 0 and is_struct(dto) == false do
    with {:ok, value_name} <- Name.new(dto[:name]),
         {:ok, value_surname} <- Surname.new(dto[:surname]),
         {:ok, value_email} <- Email.new(dto[:email]),
         {:ok, value_phone} <- PhoneNumber.new(dto[:phone]),
         {:ok, value_password} <- Password.new(dto[:password]),
         {:ok, avatar_entity} <- AvatarEntity.new(dto[:avatar]) do
      {
        :ok,
        %UserAggregate{
          name: value_name,
          surname: value_surname,
          email: value_email,
          phone: value_phone,
          password: value_password,
          avatar: avatar_entity,
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

  @spec validate_password(UserAggregate.t(), binary()) :: {:ok, true} | error()
  def validate_password(%UserAggregate{} = entity, password)
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

  @spec update(UserAggregate.t(), updating_dto()) :: ok() | error()
  def update(%UserAggregate{} = entity, %{} = dto)
      when is_map(dto) and is_struct(dto) == false and map_size(dto) > 0 and is_struct(entity) do
    case is_empty(dto) do
      true -> {:error, DomainError.new("Invalid input data")}
      false ->
        update_name({:ok, entity}, dto)
        |> update_surname(dto)
        |> update_email(dto)
        |> update_phone(dto)
        |> update_password(dto)
        |> update_avatar(dto)
    end
  end

  def update(_, _) do
    {:error, DomainError.new("Invalid input data")}
  end

  defp update_name({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:name] != nil,
         {:ok, value_name} <- Name.new(dto[:name]) do
      {:ok, %UserAggregate{maybe_entity | name: value_name}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_surname({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:surname] != nil,
         {:ok, value_surname} <- Surname.new(dto[:surname]) do
      {:ok, %UserAggregate{maybe_entity | surname: value_surname}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_email({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:email] != nil,
         {:ok, value_email} <- Email.new(dto[:email]) do
      {:ok, %UserAggregate{maybe_entity | email: value_email}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_phone({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:phone] != nil,
         {:ok, value_phone} <- PhoneNumber.new(dto[:phone]) do
      {:ok, %UserAggregate{maybe_entity | phone: value_phone}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_password({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:password] != nil,
         {:ok, value_password} <- Password.new(dto[:password]) do
      {:ok, %UserAggregate{maybe_entity | password: value_password}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_avatar({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:avatar] != nil,
         {:ok, avatar_entity} <- AvatarEntity.update(maybe_entity.avatar, dto[:avatar]) do
      {:ok, %UserAggregate{maybe_entity | avatar: avatar_entity}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp is_empty(%{} = dto) do
    cond do
      Map.has_key?(dto, :name) == true -> false
      Map.has_key?(dto, :surname) == true -> false
      Map.has_key?(dto, :email) == true -> false
      Map.has_key?(dto, :phone) == true -> false
      Map.has_key?(dto, :password) == true -> false
      Map.has_key?(dto, :avatar) == true -> false
      true -> true
    end
  end
end
