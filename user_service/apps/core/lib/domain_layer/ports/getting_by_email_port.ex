defmodule Core.DomainLayer.Ports.GettingByEmailPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.NotFoundError

  alias Core.DomainLayer.ValueObjects.Email

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.UserEntity

  @type ok :: {:ok, UserEntity.t()}

  @type error :: {:error, NotFoundError.t() | ImpossibleGetError.t()}

  @callback get_by_email(Email.t()) :: ok() | error()
end
