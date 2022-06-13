defmodule Core.CoreDomains.Domains.Password.Ports.GettingConfirmingCodePort do
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode

  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError
  alias Core.CoreDomains.Common.Dtos.MapToDomainError
  alias Core.CoreDomains.Common.Dtos.ImpossibleGetError
  alias Core.CoreDomains.Common.Dtos.NotFoundError

  @type t :: module

  @type error :: {:error, NotFoundError.t() | ImpossibleCallError.t() | MapToDomainError.t() | ImpossibleGetError.t()}

  @type ok :: {:ok, ConfirmingCode.t()}

  @callback get(binary) :: ok | error
end
