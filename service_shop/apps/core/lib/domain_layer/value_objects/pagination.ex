defmodule Core.DomainLayer.ValueObjects.Pagination do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Pagination
  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  defstruct limit: nil, offset: nil

  @type t :: %Pagination{
          limit: integer(),
          offset: integer()
        }

  @type ok :: {:ok, Pagination.t()}

  @type error :: {:error, ImpossibleCreateError.t()}

  @spec new(integer(), integer()) :: ok() | error()
  def new(limit, offset) when is_integer(limit) and is_integer(offset) do
    with true <- limit > 0,
         true <- offset > 0 do
      {
        :ok,
        %Pagination{
          limit: limit,
          offset: offset
        }
      }
    else
      false -> {:error, ImpossibleCreateError.new()}
    end
  end

  def new(_, _) do
    {:error, ImpossibleCreateError.new()}
  end
end
