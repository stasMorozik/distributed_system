defmodule Core.DomainLayer.Common.ValueObjects.Name do
  alias Core.DomainLayer.Common.ValueObjects.Name
  alias Core.DomainLayer.Common.Dtos.NameIsInvalidError

  defstruct value: nil

  @type t :: %Name{value: binary}

  @type ok ::
  {
    :ok,
    Name.t()
  }

  @type error ::
  {
    :error,
    NameIsInvalidError.t()
  }

  @spec new(binary) :: ok | error
  def new(nm) when is_binary(nm) do
    case String.match?(nm, ~r/^[a-zA-Z]+$/) do
      :true -> {:ok, %Name{value: nm}}
      :false -> {:error, NameIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, NameIsInvalidError.new()}
  end
end
