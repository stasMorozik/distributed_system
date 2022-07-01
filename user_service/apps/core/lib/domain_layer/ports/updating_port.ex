defmodule Core.DomainLayer.Ports.UpdatingPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Core.DomainLayer.UserEntity

  @type ok :: {:ok, true}

  @type error :: {:error, AlreadyExistsError.t()}

  @callback update(UserEntity.t()) :: ok() | error()
end
