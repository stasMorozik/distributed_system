defmodule Core.CoreDomains.Domains.User.Ports.GettingPort do
  alias Core.CoreDomains.Domains.User

  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.MapToDomainError
  alias Core.CoreDomains.Common.Dtos.ImpossibleGetError
  alias Core.CoreDomains.Common.Dtos.NotFoundError

  @type t :: module

  @type error :: {:error, NotFoundError.t() | MapToDomainError.t() | ImpossibleCallError.t() | ImpossibleGetError.t() | IdIsInvalidError.t()}

  @type ok :: {:ok, User.t()}

  @callback get(binary) :: ok | error
end
