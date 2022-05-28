defmodule Core.CoreDomains.Domains.User.Commands.RegisteringCommand do
  alias Core.CoreDomains.Domains.User.Commands.RegisteringCommand

  defstruct email: nil, password: nil, name: nil

  @type t :: %RegisteringCommand{email: binary, password: binary, name: binary}

  @spec new(binary, binary, binary) :: RegisteringCommand.t()
  def new(email, password, name) do
    %RegisteringCommand{email: email, password: password, name: name}
  end
end
