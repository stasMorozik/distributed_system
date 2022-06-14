defmodule Core.CoreDomains.Domains.User.Commands.ChangingEmailCommand do
  alias Core.CoreDomains.Domains.User.Commands.ChangingEmailCommand

  defstruct token: nil, new_email: nil, code: nil

  @type t :: %ChangingEmailCommand{token: binary, new_email: binary, code: integer}

  @spec new(binary) :: ChangingEmailCommand.t()
  def new(token, new_email, code) do
    %ChangingEmailCommand{token: token, new_email: new_email, code: code}
  end
end
