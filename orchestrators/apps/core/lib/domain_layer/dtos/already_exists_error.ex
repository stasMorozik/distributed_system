defmodule Core.DomainLayer.Dtos.AlreadyExistsError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.AlreadyExistsError

  defstruct message: nil

  @type t :: %AlreadyExistsError{message: binary}
end
