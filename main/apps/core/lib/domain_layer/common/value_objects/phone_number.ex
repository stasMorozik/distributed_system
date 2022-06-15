defmodule Core.DomainLayer.Common.ValueObjects.PhoneNumber do
  alias Core.DomainLayer.Common.ValueObjects.PhoneNumber
  alias Core.DomainLayer.Common.Dtos.PhoneNumberIsInvalidError

  defstruct value: nil

  @type t :: %PhoneNumber{value: binary}

  @type ok ::
  {
    :ok,
    PhoneNumber.t()
  }

  @type error ::
  {
    :error,
    PhoneNumberIsInvalidError.t()
  }

  @spec new(binary) :: ok | error
  def new(ph) when is_binary(ph) do
    case String.length(ph) >= 5 && String.length(ph) <= 17  do
      :false -> {:error, PhoneNumberIsInvalidError.new()}
      :true ->
        case String.match?(ph, ~r/^[0-9]+$/) do
          :true -> {:ok, %PhoneNumber{value: ph}}
          :false -> {:error, PhoneNumberIsInvalidError.new()}
        end
    end
  end

  def new(_) do
    {:error, PhoneNumberIsInvalidError.new()}
  end

end
