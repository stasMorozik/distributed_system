defmodule Core.CoreDomains.Domains.Password.Ports.ChangingPasswordPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.NotFoundError
  alias Core.CoreDomains.Common.Dtos.ImpossibleUpdateError

  @type t :: module

  @type error :: {:error, NotFoundError.t() | ImpossibleUpdateError.t() | ImpossibleCallError.t() | IdIsInvalidError.t()}

  @type ok :: {:ok, Password.t()}

  @callback change(Password.t()) :: ok | error
end
