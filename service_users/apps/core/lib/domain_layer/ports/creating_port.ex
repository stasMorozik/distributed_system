defmodule Core.DomainLayer.Ports.CreatingPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Core.DomainLayer.UserEntity

  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, AlreadyExistsError.t() | ImpossibleCreateError.t()}

  @callback create(UserEntity.t()) :: ok() | error()
end
