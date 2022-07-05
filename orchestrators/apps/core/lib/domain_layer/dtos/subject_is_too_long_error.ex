defmodule Core.DomainLayer.Dtos.SubjectIsTooLongError do
  @moduledoc false

  alias Core.DomainLayer.Dtos.SubjectIsTooLongError

  defstruct message: nil

  @type t :: %SubjectIsTooLongError{message: binary()}
end
