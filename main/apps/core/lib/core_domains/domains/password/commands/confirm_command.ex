defmodule Core.CoreDomains.Domains.Password.Commands.ConfirmCommand do
  alias Core.CoreDomains.Domains.Password.Commands.ConfirmCommand

  defstruct email: nil, password: nil

  @type t :: %ConfirmCommand{email: binary, password: binary}

  @spec new(binary, binary) :: ConfirmCommand.t()
  def new(email, password) do
    %ConfirmCommand{email: email, password: password}
  end
end
