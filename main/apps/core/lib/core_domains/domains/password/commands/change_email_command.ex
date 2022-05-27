defmodule Core.CoreDomains.Domains.Password.Commands.ChangeEmailCommand do
  alias Core.CoreDomains.Domains.Password.Commands.ChangeEmailCommand

  defstruct id: nil, password: nil, new_email: nil

  @type t :: %ChangeEmailCommand{id: binary, password: binary, new_email: binary}

  @spec new(binary, binary, binary) :: ChangeEmailCommand.t()
  def new(id, password, new_email) do
    %ChangeEmailCommand{id: id, password: password, new_email: new_email}
  end
end
