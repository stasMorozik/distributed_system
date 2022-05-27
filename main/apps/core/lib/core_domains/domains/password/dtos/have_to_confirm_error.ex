defmodule Core.CoreDomains.Domains.Password.Dtos.HaveToConfirmError do
  alias Core.CoreDomains.Domains.Password.Dtos.HaveToConfirmError

  defstruct message: nil

  @type t :: %HaveToConfirmError{message: binary}

  @spec new :: HaveToConfirmError.t()
  def new() do
    %HaveToConfirmError{message: "You have to confirm the password"}
  end
end
