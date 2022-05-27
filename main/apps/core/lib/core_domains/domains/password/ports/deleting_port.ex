defmodule Core.CoreDomains.Domains.Password.Ports.DeletingPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Dtos.NotFoundError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleDeleteError

  @type t :: module

  @type error :: {:error, NotFoundError.t() | ImpossibleDeleteError.t()}

  @type ok :: {:ok, Password.t()}

  @callback delete(Password.t()) :: ok | error
end
