defmodule Core.DomainLayer.Common.Dtos.AlreadyExistsError do
  alias Core.DomainLayer.Common.Dtos.AlreadyExistsError

  defstruct message: nil

  @type t :: %AlreadyExistsError{message: binary}

  @spec new(binary) :: AlreadyExistsError.t()
  def new(mess) when is_binary(mess) do
    %AlreadyExistsError{message: mess}
  end

  def new(_) do
    %AlreadyExistsError{message: "Entity already exists"}
  end
end
