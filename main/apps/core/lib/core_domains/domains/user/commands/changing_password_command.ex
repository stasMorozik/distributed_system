defmodule Core.CoreDomains.Domains.User.Commands.ChangingPasswordCommand do
  alias Core.CoreDomains.Domains.User.Commands.ChangingPasswordCommand

  defstruct token: nil, new_email: nil, code: nil

  @type t :: %ChangingPasswordCommand{token: binary, new_password: binary, old_password: binary}

  @spec new(binary) :: ChangingPasswordCommand.t()
  def new(token, new_password, old_password) do
    %ChangingPasswordCommand{token: token, new_password: new_password, old_password: old_password}
  end
end
