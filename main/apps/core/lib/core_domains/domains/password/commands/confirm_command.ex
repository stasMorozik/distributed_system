defmodule Core.CoreDomains.Domains.Password.Commands.ConfirmCommand do
  alias Core.CoreDomains.Domains.Password.Commands.ConfirmCommand

  defstruct email: nil, password: nil, code: nil

  @type t :: %ConfirmCommand{email: binary, password: binary, code: integer}

  @spec new(binary, binary, integer) :: ConfirmCommand.t()
  def new(email, password, code) do
    %ConfirmCommand{email: email, password: password, code: code}
  end
end
