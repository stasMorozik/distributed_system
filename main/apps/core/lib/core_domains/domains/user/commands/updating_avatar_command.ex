defmodule Core.CoreDomains.Domains.User.Commands.UpdatingAvatarCommand do
  alias Core.CoreDomains.Domains.User.Commands.UpdatingAvatarCommand

  defstruct token: nil, avatar: nil

  @type t :: %UpdatingAvatarCommand{token: binary(), avatar: binary()}

  @spec new(binary) :: UpdatingAvatarCommand.t()
  def new(token, avatar) do
    %UpdatingAvatarCommand{token: token, avatar: avatar}
  end
end
