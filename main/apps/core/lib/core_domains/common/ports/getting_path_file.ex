defmodule Core.CoreDomains.Common.Ports.GettingPathFile do
  alias Core.CoreDomains.Common.Dtos.NotFoundError

  @type t :: module

  @type ok :: {:ok, binary()}
  @type error :: {:error, NotFoundError.t()}

  @callback get(binary()) :: ok() | error()
end
