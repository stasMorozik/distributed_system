defmodule DeletingAdapter do
  @moduledoc false

  import Ecto.Query
  alias Codes.Repo

  alias Core.DomainLayer.Ports.DeletingPort
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.Errors.InfrastructureError

  alias Codes.CodesSchema

  @behaviour DeletingPort

  @spec delete(Email.t()) :: DeletingPort.ok() | DeletingPort.error()
  def delete(%Email{value: email}) do
    case Repo.transaction(fn ->
      from(c in CodesSchema, where: c.email == ^email) |> Repo.delete_all(:delete_code)
    end) do
      {:ok, _} -> {:ok, true}
      _ -> {:error, InfrastructureError.new("Code not found")}
    end
  end

  def delete(_) do
    {:error, InfrastructureError.new("Invalid input data for deleting")}
  end
end
