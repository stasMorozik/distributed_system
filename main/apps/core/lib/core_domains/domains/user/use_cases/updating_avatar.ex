defmodule Core.CoreDomains.Domains.User.UseCases.UpdatingAvatar do
  alias Core.CoreDomains.Domains.User.Commands.UpdatingAvatarCommand

  alias Core.CoreDomains.Domains.Token
  alias Core.CoreDomains.Domains.User

  alias Core.CoreDomains.Domains.User.Ports.GettingPort
  alias Core.CoreDomains.Common.Ports.StoragingFile

  @type t :: module

  @type error :: Token.error() | User.error() | GettingPort.error() | StoragingFile.error()

  @type ok :: {:ok, User.t()}

  @callback update(UpdatingAvatarCommand.t(), GettingPort.t(), StoragingFile.t()) :: error | ok

end
