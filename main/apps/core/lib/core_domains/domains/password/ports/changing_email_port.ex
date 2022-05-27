defmodule Core.CoreDomains.Domains.Password.Ports.ChangingEmailPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Dtos.AlreadyExistsError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeEmailError

  @type t :: module

  @type error :: {:error, AlreadyExistsError.t() | ImpossibleChangeEmailError.t()}

  @type ok :: {:ok, Password.t()}

  @callback change(Password.t()) :: ok | error
end
