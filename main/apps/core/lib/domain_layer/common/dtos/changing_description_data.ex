defmodule Core.DomainLayer.Common.Dtos.ChangingDescriptionData do
  @moduledoc false

  alias Core.DomainLayer.Common.Dtos.ChangingDescriptionData

  defstruct description: nil

  @type t :: %ChangingDescriptionData{
    description: binary()
        }

  @spec new(binary()) :: ChangingDescriptionData.t()
  def new(description) do
    %ChangingDescriptionData{
      description: description
    }
  end
end
