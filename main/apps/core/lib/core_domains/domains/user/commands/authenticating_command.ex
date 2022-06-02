defmodule Core.CoreDomains.Domains.User.Commands.AuthenticatingCommand do
  alias Core.CoreDomains.Domains.User.Commands.AuthenticatingCommand

  defstruct email: nil, password: nil

  @type t :: %AuthenticatingCommand{email: binary, password: binary}

  @spec new(binary, binary) :: AuthenticatingCommand.t()
  def new(email, password) do
    %AuthenticatingCommand{email: email, password: password}
  end
end
