defmodule Core.DomainLayer.Common.ValueObjects.ConfirmingCode do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.ConfirmingCode
  alias Core.DomainLayer.Common.Dtos.EmailIsInvalidError

  defstruct code: nil, email: nil

  @type t :: %ConfirmingCode{
          code: integer(),
          email: binary()
        }

  @type ok :: {
          :ok,
          ConfirmingCode.t()
        }

  @type error :: {
          :error,
          EmailIsInvalidError.t()
        }

  @spec new(binary) :: ConfirmingCode.t()
  def new(email) when is_binary(email) do
    case String.match?(email, ~r/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/) do
      true ->
        {:ok,
         %ConfirmingCode{
           code: Enum.random(1_000..9_999),
           email: email
         }}

      false ->
        {:error, EmailIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, EmailIsInvalidError.new()}
  end
end
