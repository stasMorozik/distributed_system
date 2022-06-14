defmodule Core.CoreDomains.Common.Ports.StoragingFiles do
  alias Core.CoreDomains.Common.Dtos.ImpossibleCreateError

  @type t :: module

  @type ok :: {:ok, nonempty_list(binary())}
  @type error :: {:error, ImpossibleCreateError.t()}

  @callback storage(nonempty_list(binary())) :: nonempty_list(binary())
end
