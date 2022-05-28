defmodule Core.CoreDomains.Domains.User.Ports.CreatingPort do
  alias Core.CoreDomains.Domains.User

  alias Core.CoreDomains.Domains.User.Dtos.ImpossibleCreateError

  @type error :: {:error, ImpossibleCreateError.t()}

  @type ok :: {:ok, User.t()}

  @callback create(User.t()) :: error | ok
end
