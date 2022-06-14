defmodule Core.CoreDomains.Domains.User.Commands.ConfirmEmailCommand do
  alias Core.CoreDomains.Domains.User.Commands.ConfirmEmailCommand

  defstruct email: nil

  @type t :: %ConfirmEmailCommand{email: binary}

  @spec new(binary) :: ConfirmEmailCommand.t()
  def new(email) do
    %ConfirmEmailCommand{email: email}
  end
end
