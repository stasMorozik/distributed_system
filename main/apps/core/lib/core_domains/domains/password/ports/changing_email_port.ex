defmodule Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Dtos.AlreadyExistsError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeEmailError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError

  @type t :: module

  @type error :: {:error, AlreadyExistsError.t() | ImpossibleCallError.t() | ImpossibleChangeEmailError.t() | IdIsInvalidError.t()}

  @type ok :: {:ok, Password.t()}

  @callback change(Password.t()) :: ok | error
end
