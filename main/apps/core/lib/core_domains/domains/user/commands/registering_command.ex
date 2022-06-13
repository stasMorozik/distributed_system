defmodule Core.CoreDomains.Domains.User.Commands.RegisteringCommand do
  alias Core.CoreDomains.Domains.User.Commands.RegisteringCommand

  defstruct email: nil, password: nil, name: nil, code: nil

  @type t :: %RegisteringCommand{email: binary, password: binary, name: binary, code: integer}

  @spec new(binary, binary, binary, integer) :: RegisteringCommand.t()
  def new(email, password, name, code) do
    %RegisteringCommand{email: email, password: password, name: name, code: code}
  end
end
