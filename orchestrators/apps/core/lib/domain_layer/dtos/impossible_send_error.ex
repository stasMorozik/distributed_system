defmodule Core.DomainLayer.Dtos.ImpossibleSendError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleSendError

  defstruct message: nil

  @type t :: %ImpossibleSendError{message: binary}
end
