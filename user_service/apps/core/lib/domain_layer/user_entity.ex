defmodule Core.DomainLayer.UserEntity do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Image
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.PhoneNumber
  alias Core.DomainLayer.ValueObjects.Name
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Surname
  alias Core.DomainLayer.ValueObjects.Password

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.PasswordIsNotTrueError
  alias Core.DomainLayer.Dtos.ImpossibleValidatePasswordError
  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

  alias Core.DomainLayer.UserEntity

  defstruct name: nil,
            surname: nil,
            email: nil,
            phone: nil,
            password: nil,
            avatar: nil,
            id: nil,
            created: nil

  @type t :: %UserEntity{
          name: Name.t(),
          surname: Surname.t(),
          email: Email.t(),
          phone: PhoneNumber.t(),
          password: Password.t(),
          avatar: Image.t(),
          id: Id.t(),
          created: Created.t()
        }

  @type ok :: {
          :ok,
          UserEntity.t()
        }

  @type error_creating ::
          Surname.error()
          | Name.error()
          | PhoneNumber.error()
          | Password.error()
          | Email.error()
          | Image.error()
          | {:error, ImpossibleCreateError.t()}

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
            name: any(),
            surname: any(),
            email: any(),
            phone: any(),
            password: any(),
            avatar: any()
          }

  @type error_updating ::
          Surname.error()
          | Name.error()
          | PhoneNumber.error()
          | Password.error()
          | Email.error()
          | Image.error()
          | {:error, ImpossibleUpdateError.t()}

  @type error_validating_password :: {
          :error,
          PasswordIsNotTrueError.t()
          | ImpossibleValidatePasswordError.t()
        }

  @spec new(creating_dto()) :: ok() | error_creating()
  def new(dto = %{}) when is_map(dto) and map_size(dto) > 0 and is_struct(dto) == false do
    with {:ok, value_name} <- Name.new(dto[:name]),
         {:ok, value_surname} <- Surname.new(dto[:surname]),
         {:ok, value_email} <- Email.new(dto[:email]),
         {:ok, value_phone} <- PhoneNumber.new(dto[:phone]),
         {:ok, value_password} <- Password.new(dto[:password]),
         {:ok, value_image} <- Image.new(dto[:avatar]) do
      {
        :ok,
        %UserEntity{
          name: value_name,
          surname: value_surname,
          email: value_email,
          phone: value_phone,
          password: value_password,
          avatar: value_image,
          id: Id.new(),
          created: Created.new()
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end

  @spec validate_password(UserEntity.t(), binary()) :: {:ok, true} | error_validating_password()
  def validate_password(%UserEntity{} = entity, password)
      when is_struct(entity) and is_binary(password) do
    with true <- is_binary(password),
         true <- Bcrypt.verify_pass(password, entity.password.value) do
      {:ok, true}
    else
      false -> {:error, PasswordIsNotTrueError.new()}
    end
  end

  def validate_password(_, _) do
    {:error, ImpossibleValidatePasswordError.new()}
  end

  @spec update(UserEntity.t(), updating_dto()) :: ok() | error_updating()
  def update(%UserEntity{} = entity, %{} = dto)
      when is_map(dto) and is_struct(dto) == false and map_size(dto) > 0 and is_struct(entity) do

    case is_empty(dto) do
      true -> {:error, ImpossibleUpdateError.new()}
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
    {:error, ImpossibleUpdateError.new()}
  end

  defp update_name({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:name] != nil,
         {:ok, value_name} <- Name.new(dto[:name]) do
      {:ok, %UserEntity{maybe_entity | name: value_name}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_surname({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:surname] != nil,
         {:ok, value_surname} <- Surname.new(dto[:surname]) do
      {:ok, %UserEntity{maybe_entity | surname: value_surname}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_email({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:email] != nil,
         {:ok, value_email} <- Email.new(dto[:email]) do
      {:ok, %UserEntity{maybe_entity | email: value_email}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_phone({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:phone] != nil,
         {:ok, value_phone} <- PhoneNumber.new(dto[:phone]) do
      {:ok, %UserEntity{maybe_entity | phone: value_phone}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_password({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:password] != nil,
         {:ok, value_password} <- Password.new(dto[:password]) do
      {:ok, %UserEntity{maybe_entity | password: value_password}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_avatar({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:avatar] != nil,
         {:ok, value_avatar} <- Image.new(dto[:avatar]) do
      {:ok, %UserEntity{maybe_entity | avatar: value_avatar}}
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
#{:ok, user} = UserEntity.new(%{name: "test", surname: "test", email: "test@gmail.com", phone: "12345678", password: "123456", avatar: "1sds345"})
