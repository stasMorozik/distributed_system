defmodule Core.DomainLayer.Domains.User.ValueObjects.Surname do
  alias Core.DomainLayer.Domains.User.ValueObjects.Surname
  alias Core.DomainLayer.Domains.User.Dtos.SurnameIsInvalidError

  defstruct value: nil

  @type t :: %Surname{value: binary}

  @type ok ::
  {
    :ok,
    Surname.t()
  }

  @type error ::
  {
    :error,
    SurnameIsInvalidError.t()
  }

  @spec new(binary) :: ok | error
  def new(nm) when is_binary(nm) do
    case String.match?(nm, ~r/^[a-zA-Z]+$/) do
      :true -> {:ok, %Surname{value: nm}}
      :false -> {:error, SurnameIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, SurnameIsInvalidError.new()}
  end
end
