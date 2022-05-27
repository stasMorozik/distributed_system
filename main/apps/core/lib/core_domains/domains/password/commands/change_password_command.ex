defmodule Core.CoreDomains.Domains.Password.Commands.ChangePasswordCommand do
  alias Core.CoreDomains.Domains.Password.Commands.ChangePasswordCommand

  defstruct id: nil, password: nil, new_password: nil

  @type t :: %ChangePasswordCommand{id: binary, password: binary, new_password: binary}

  @spec new(binary, binary, binary) :: ChangePasswordCommand.t()
  def new(id, password, new_password) do
    %ChangePasswordCommand{id: id, password: password, new_password: new_password}
  end
end
