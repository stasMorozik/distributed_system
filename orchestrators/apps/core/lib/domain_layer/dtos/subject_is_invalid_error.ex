defmodule Core.DomainLayer.Dtos.SubjectIsInvalidError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.SubjectIsInvalidError

  defstruct message: nil

  @type t :: %SubjectIsInvalidError{message: binary()}
end
