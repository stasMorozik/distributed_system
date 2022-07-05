defmodule Core.DomainLayer.Ports.UpdatingPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

  alias Core.DomainLayer.UserEntity

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, AlreadyExistsError.t() | ImpossibleUpdateError.t()}

  @callback update(UserEntity.t()) :: ok() | error()
end
