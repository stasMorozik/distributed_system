defmodule Core.DomainLayer.Common.Dtos.ConfirmingEmailData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ConfirmingEmailData

  defstruct email: nil

  @type t :: %ConfirmingEmailData{email: binary()}

  @spec new(binary()) :: ConfirmingEmailData.t()
  def new(email) do
    %ConfirmingEmailData{email: email}
  end
end
