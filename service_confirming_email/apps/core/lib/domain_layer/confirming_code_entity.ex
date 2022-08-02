defmodule Core.DomainLayer.ConfirmingCodeEntity do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Code

  alias Core.DomainLayer.Errors.DomainError

  alias Core.DomainLayer.ConfirmingCodeEntity

  defstruct id: nil, email: nil, code: nil, created: nil

  @type t :: %ConfirmingCodeEntity{
          id: Id.t(),
          email: Email.t(),
          code: Code.t(),
          created: Created.t()
        }

  @type ok :: {
          :ok,
          ConfirmingCodeEntity.t()
        }

  @type error :: {
          :error,
          DomainError.t()
        }

  @spec from_origin(ConfirmingCodeEntity.t()) :: ok() | error()
  def from_origin(%ConfirmingCodeEntity{
        id: %Id{value: id},
        email: %Email{value: email},
        code: _,
        created: %Created{value: created}
      })
      when is_struct(created) and is_binary(id) and is_binary(email) do
    is_date_time = fn
      %DateTime{} = _ -> 1
      _ -> 0
    end

    with 1 <- is_date_time.(created),
         now <- DateTime.utc_now() |> DateTime.to_unix(),
         past <- created |> DateTime.to_unix(),
         true <- now - past > 300,
         {:ok, value_email} <- Email.new(email),
         {:ok, value_id} <- Id.from_origin(id) do


      {
        :ok,
        %ConfirmingCodeEntity{
          id: value_id,
          email: value_email,
          created: Created.new(),
          code: Code.new()
        }
      }
    else
      0 -> {:error, DomainError.new("Invalid input data")}
      {:error, error_dto} -> {:error, error_dto}
      false -> {:error, DomainError.new("Code already exists")}
    end
  end

  def from_origin(_) do
    {:error, DomainError.new("Invalid input data")}
  end

  @spec new(binary()) :: ok() | error()
  def new(maybe_email) when is_binary(maybe_email) do
    case Email.new(maybe_email) do
      {:error, error_dto} ->
        {:error, error_dto}

      {:ok, value_email} ->
        {
          :ok,
          %ConfirmingCodeEntity{
            id: Id.new(),
            email: value_email,
            created: Created.new(),
            code: Code.new()
          }
        }
    end
  end

  def new(_) do
    {:error, DomainError.new("Invalid input data")}
  end

  @spec validate_code(integer(), ConfirmingCodeEntity.t()) :: {:ok, true} | error()
  def validate_code(
        maybe_own_code,
        %ConfirmingCodeEntity{id: _, email: _, created: _, code: %Code{value: code}}
      )
      when is_integer(maybe_own_code) do
    with {:ok, value_coe} <- Code.from_origin(code),
         true <- maybe_own_code == value_coe.value do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
      false -> {:error, DomainError.new("Wrong code")}
    end
  end

  def validate_code(_, _) do
    {:error, DomainError.new("Invalid input data")}
  end
end
