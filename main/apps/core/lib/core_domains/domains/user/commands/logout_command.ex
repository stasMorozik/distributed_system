defmodule Core.CoreDomains.Domains.User.Commands.LogoutCommand do
  alias Core.CoreDomains.Domains.User.Commands.LogoutCommand

  defstruct token: nil

  @type t :: %LogoutCommand{token: binary}

  @spec new(binary) :: LogoutCommand.t()
  def new(token) do
    %LogoutCommand{token: token}
  end
end
