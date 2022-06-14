defmodule Core.CoreDomains.Domains.Password.Commands.ConfirmingEmailCommand do
  alias Core.CoreDomains.Domains.Password.Commands.ConfirmingEmailCommand

  defstruct email: nil

  @type t :: %ConfirmingEmailCommand{email: binary}

  @spec new(binary) :: ConfirmingEmailCommand.t()
  def new(email) do
    %ConfirmingEmailCommand{email: email}
  end
end
