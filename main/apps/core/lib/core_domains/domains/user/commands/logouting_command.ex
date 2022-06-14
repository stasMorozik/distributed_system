defmodule Core.CoreDomains.Domains.User.Commands.LogoutingCommand do
  alias Core.CoreDomains.Domains.User.Commands.LogoutingCommand

  defstruct token: nil

  @type t :: %LogoutingCommand{token: binary}

  @spec new(binary) :: LogoutingCommand.t()
  def new(token) do
    %LogoutingCommand{token: token}
  end
end
