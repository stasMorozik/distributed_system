defmodule Core.DomainLayer.Common.ValueObjects.Pagination do
  @moduledoc false

  alias Core.DomainLayer.Common.ValueObjects.Pagination

  alias Core.DomainLayer.Common.Dtos.ImpossibleCreateError

  defstruct take: nil, from: nil, to: nil

  @type t :: %Pagination{
          take: integer(),
          from: integer(),
          to: integer()
        }

  @type ok :: {
          :ok,
          Pagination.t()
        }

  @type error :: {
          :error,
          ImpossibleCreateError.t()
        }

  @spec new(integer(), integer(), integer()) :: ok() | error()
  def new(take, from, to)
      when is_integer(take) and is_integer(from) and is_integer(to) do
    with true <- take > 0,
         true <- from >= 0,
         true <- to > 0,
         true <- from < to,
         true <- to - from == take do
      {
        :ok,
        %Pagination{
          take: take,
          from: from,
          to: to
        }
      }
    else
      false ->

        {
          :error,
          ImpossibleCreateError.new("Impossible create object of pagination for invalid data")
        }
    end
  end

  def new(_, _, _) do
    ImpossibleCreateError.new("Impossible create object of pagination for invalid data")
  end
end
