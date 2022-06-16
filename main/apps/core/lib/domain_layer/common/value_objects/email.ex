defmodule Core.DomainLayer.Common.ValueObjects.Email do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Email
  alias Core.DomainLayer.Common.Dtos.EmailIsInvalidError

  defstruct value: nil

  @type t :: %Email{value: binary}

  @type ok :: {ok, Email.t()}

  @type error :: {:error, EmailIsInvalidError.t()}

  @spec new(binary) :: ok | error
  def new(em) when is_binary(em) do
    case String.match?(em, ~r/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/) do
      true -> {:ok, %Email{value: em}}
      false -> {:error, EmailIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, EmailIsInvalidError.new()}
  end
end
