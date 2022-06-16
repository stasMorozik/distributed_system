defmodule Core.DomainLayer.Common.Ports.GettingPathFile do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.NotFoundError

  @type t :: module

  @type ok :: {:ok, binary()}
  @type error :: {:error, NotFoundError.t()}

  @callback get(binary()) :: ok() | error()
end
