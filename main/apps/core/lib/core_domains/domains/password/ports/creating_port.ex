defmodule Core.CoreDomains.Domains.Password.Ports.CreatingPort do
  alias Core.CoreDomains.Domains.Password

  alias Core.CoreDomains.Common.Dtos.AlreadyExistsError
  alias Core.CoreDomains.Common.Dtos.IdIsInvalidError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError
  alias Core.CoreDomains.Common.Dtos.ImpossibleCreateError

  @type t :: module

  @type error :: {:error, AlreadyExistsError.t() | ImpossibleCreateError.t() | ImpossibleCallError.t() | IdIsInvalidError.t()}

  @type ok :: {:ok, Password.t()}

  @callback create(Password.t()) :: error | ok
end
