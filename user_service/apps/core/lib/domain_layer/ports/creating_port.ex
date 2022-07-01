defmodule Core.DomainLayer.Ports.CreatingPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Core.DomainLayer.UserEntity

  @type ok :: {:ok, true}

  @type error :: {:error, AlreadyExistsError.t()}

  @callback create(UserEntity.t()) :: ok() | error()
end
