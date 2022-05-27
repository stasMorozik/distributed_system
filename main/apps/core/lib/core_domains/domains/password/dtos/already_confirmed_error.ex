defmodule Core.CoreDomains.Domains.Password.Dtos.AlreadyConfirmedError do
  alias Core.CoreDomains.Domains.Password.Dtos.AlreadyConfirmedError

  defstruct message: nil

  @type t :: %AlreadyConfirmedError{message: binary}

  @spec new :: AlreadyConfirmedError.t()
  def new() do
    %AlreadyConfirmedError{message: "Password already confirmed"}
  end
end
