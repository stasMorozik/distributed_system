defmodule Core.CoreDomains.Domains.Password.Ports.ChangingPasswordPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Dtos.NotFoundError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleChangeError

  @type t :: module

  @type error :: {:error, NotFoundError.t() | ImpossibleChangeError.t()}

  @type ok :: {:ok, Password.t()}

  @callback change(Password.t()) :: ok | error
end
