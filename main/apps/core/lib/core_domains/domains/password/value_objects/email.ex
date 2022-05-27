defmodule Core.CoreDomains.Domains.Password.ValueObjects.Email do
  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Domains.Password.Dtos.EmailIsInvalidError

  defstruct value: nil

  @type t :: %Email{value: binary}

  @type ok ::
  {
    :ok,
    Email.t()
  }

  @type error ::
  {
    :error,
    EmailIsInvalidError.t()
  }

  @spec new(binary) :: ok | error
  def new(em) when is_binary(em) do
    case String.match?(em, ~r/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/) do
      :true -> {:ok, %Email{value: em}}
      :false -> {:error, EmailIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, EmailIsInvalidError.new()}
  end
end
