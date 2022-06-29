defmodule Core.DomainLayer.Common.Ports.StoragingFilePort do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError

  alias Core.DomainLayer.Common.ValueObjects.Image

  alias Core.DomainLayer.Common.ValueObjects.Id

  @type t :: module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleCreateError.t()}

  @callback storage(list(Image.t()), Id.t()) :: ok() | error()
end
