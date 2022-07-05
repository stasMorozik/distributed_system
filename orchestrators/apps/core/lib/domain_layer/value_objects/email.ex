defmodule Core.DomainLayer.ValueObjects.Email do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Email

  defstruct value: nil

  @type t :: %Email{value: binary}
end
