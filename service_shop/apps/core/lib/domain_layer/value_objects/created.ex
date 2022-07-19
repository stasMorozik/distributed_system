defmodule Core.DomainLayer.ValueObjects.Created do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Created

  alias Core.DomainLayer.Dtos.DateIsInvalidError

  defstruct value: nil

  @type t :: %Created{value: DateTime.t()}

  @type ok :: {:ok, Created.t()}

  @type error :: {:error, DateIsInvalidError.t()}

  @spec new :: Created.t()
  def new do
    %Created{value: DateTime.utc_now() |> DateTime.truncate(:second)}
  end

  @spec from_unix(integer()) :: ok() | error()
  def from_unix(unix) when is_integer(unix) do
    cond do
      unix <= 0 -> {:error, DateIsInvalidError.new()}
      unix > 2_147_483_647 -> {:error, DateIsInvalidError.new()}
      true -> {:ok, DateTime.from_unix!(unix)}
    end
  end

  def from_unix(_) do
    {:error, DateIsInvalidError.new()}
  end
end
