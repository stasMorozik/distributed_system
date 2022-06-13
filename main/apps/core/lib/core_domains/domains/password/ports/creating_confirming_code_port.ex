defmodule Core.CoreDomains.Domains.Password.Ports.CreatingConfirmingCodePort do
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode

  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCreateError

  @type t :: module

  @type ok :: {:ok, ConfirmingCode.t()}

  @type error :: {:error, ImpossibleCallError.t() | ImpossibleCreateError.t()}

  @callback create(ConfirmingCode.t()) :: ok | error
end
