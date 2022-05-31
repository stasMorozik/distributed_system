defmodule Core.CoreDomains.Domains.Password.Ports.CreatingPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Domains.Password.Dtos.AlreadyExistsError
  alias Core.CoreDomains.Domains.Password.Dtos.ImpossibleCreateError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError

  @type t :: module

  @type error :: {:error, AlreadyExistsError.t() | ImpossibleCreateError.t() | IdIsInvalidError.t()}

  @type ok :: {:ok, Password.t()}

  @callback create(Password.t()) :: error | ok
end
