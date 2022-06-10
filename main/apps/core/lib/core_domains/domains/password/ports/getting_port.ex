defmodule Core.CoreDomains.Domains.Password.Ports.GettingPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Dtos.NotFoundError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleGetError
  alias Core.CoreDomains.Domains.Password.Dtos.MapToDomainError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError

  @type t :: module

  @type error :: {:error, NotFoundError.t() | MapToDomainError.t() | ImpossibleCallError.t() | ImpossibleGetError.t() | IdIsInvalidError.t()}

  @type ok :: {:ok, Password.t()}

  @callback get(binary) :: ok | error
end
