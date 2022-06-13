defmodule Core.CoreDomains.Domains.Password.Ports.DeletingPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Common.Dtos.NotFoundError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError

  alias Core.CoreDomains.Common.Dtos.ImpossibleDeleteError

  @type t :: module

  @type error :: {:error, NotFoundError.t() | ImpossibleDeleteError.t() | ImpossibleCallError.t() | IdIsInvalidError.t()}

  @type ok :: {:ok, Password.t()}

  @callback delete(Password.t()) :: ok | error
end
