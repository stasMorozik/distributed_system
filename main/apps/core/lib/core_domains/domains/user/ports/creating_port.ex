defmodule Core.CoreDomains.Domains.User.Ports.CreatingPort do
  alias Core.CoreDomains.Domains.User

  alias Core.CoreDomains.Domains.User.Dtos.ImpossibleCreateError
  alias Core.CoreDomains.Domains.User.Dtos.AlreadyExistsError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError

  @type error :: {:error, ImpossibleCreateError.t() | AlreadyExistsError.t() | ImpossibleCallError.t() | IdIsInvalidError.t()}

  @type ok :: {:ok, User.t()}

  @callback create(User.t()) :: error | ok
end
