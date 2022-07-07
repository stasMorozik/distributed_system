defmodule Core.DomainLayer.ValueObjects.Id do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Id

  alias Core.DomainLayer.Dtos.IdIsInvalidError

  defstruct value: nil

  @type t :: %Id{value: binary}

  @type ok :: {:ok, Id.t()}

  @type error :: {:error, IdIsInvalidError.t()}

  @spec from_origin(binary()) :: ok() | error()
  def from_origin(id) when is_binary(id) do
    case UUID.info(id) do
      {:error, _} -> {:error, IdIsInvalidError.new()}
      {:ok, _} -> {:ok, %Id{value: id}}
    end
  end

  def from_origin(_) do
    {:error, IdIsInvalidError.new()}
  end

  @spec new :: Id.t()
  def new do
    %Id{value: UUID.uuid4()}
  end
end
