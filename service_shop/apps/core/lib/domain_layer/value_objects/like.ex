defmodule Core.DomainLayer.ValueObjects.Like do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Like
  alias Core.DomainLayer.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Dtos.IdIsInvalidError
  alias Core.DomainLayer.Dtos.ImpossibleCreateError

  defstruct email: nil, id: nil

  @type t :: %Like{email: binary(), id: binary()}

  @type ok :: {ok, Like.t()}

  @type error :: {
          :error,
          EmailIsInvalidError.t()
          | IdIsInvalidError.t()
          | ImpossibleCreateError.t()
        }

  @spec new(binary, binary()) :: ok | error
  def new(em, id) when is_binary(em) and is_binary(id) do
    with true <- String.match?(em, ~r/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/),
         {:ok, _} <- UUID.info(id) do
      {
        :ok,
        %Like{
          email: em,
          id: id
        }
      }
    else
      false -> {:error, EmailIsInvalidError.new()}
      {:error, _} -> {:error, IdIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end
end
