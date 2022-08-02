defmodule Core.DomainLayer.ValueObjects.Code do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Code
  alias Core.DomainLayer.Errors.DomainError

  defstruct value: nil

  @type t :: %Code{
          value: integer()
        }

  @type ok :: {
          :ok,
          Code.t()
        }

  @type error :: {
          :error,
          DomainError.t()
        }

  @spec new :: Code.t()
  def new do
    %Code{
      value: Enum.random(1_000..9_999),
    }
  end

  @spec from_origin(integer()) :: ok() | error()
  def from_origin(code) when is_integer(code) do
    {:ok, %Code{value: code}}
  end

  def from_origin(_) do
    {:error, DomainError.new("Code is invalid")}
  end
end
