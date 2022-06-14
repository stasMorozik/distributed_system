defmodule Core.CoreDomains.Domains.User.Commands.AuthorizatingCommand do
  alias Core.CoreDomains.Domains.User.Commands.AuthorizatingCommand

  defstruct token: nil

  @type t :: %AuthorizatingCommand{token: binary}

  @spec new(binary) :: AuthorizatingCommand.t()
  def new(token) do
    %AuthorizatingCommand{token: token}
  end
end
