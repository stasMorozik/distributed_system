defmodule Core.CoreDomains.Domains.Password.Ports.GettingPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.MapToDomainError
  alias Core.CoreDomains.Common.Dtos.ImpossibleGetError
  alias Core.CoreDomains.Common.Dtos.NotFoundError

  @type t :: module

  @type error :: {:error, NotFoundError.t() | MapToDomainError.t() | ImpossibleCallError.t() | ImpossibleGetError.t() | IdIsInvalidError.t()}

  @type ok :: {:ok, Password.t()}

  @callback get(binary) :: ok | error
end
