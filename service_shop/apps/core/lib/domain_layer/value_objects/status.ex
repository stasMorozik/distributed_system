defmodule Core.DomainLayer.ValueObjects.Status do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Status
  alias Core.DomainLayer.Dtos.StatusIsInvalidError

  defstruct value: nil

  @type t :: %Status{value: binary}


  @type ok :: {:ok, Status.t()}

  @type error :: {:error, StatusIsInvalidError.t()}

  @spec new(binary) :: ok | error
  def new(staus_name) when is_binary(staus_name) do
    cond do
      staus_name == "Created" -> {:ok, %Status{value: staus_name}}
      staus_name == "Sent" -> {:ok, %Status{value: staus_name}}
      true -> {:error, StatusIsInvalidError.new()}
    end
  end

  def new(_) do
    {:error, StatusIsInvalidError.new()}
  end
end
