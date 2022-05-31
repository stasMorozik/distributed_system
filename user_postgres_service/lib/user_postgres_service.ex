defmodule UserPostgresService do
  alias Ecto.Multi
  alias Persons.Repo
  alias UserPostgresService.PersonsScheme
  @moduledoc """
    For way if your adapter not checking uuid type.
    Error codes
    0 - Impossimble insert into tbale because data is invalid
    1 - User with this id already exists
  """
  def create(id, name, created) when is_binary(id) and is_binary(name) do
    case UUID.info(id) do
      {:error, _} -> {:error, 0}
      {:ok, _} ->
        person = PersonsScheme.changeset(%PersonsScheme{}, %{id: id, name: name, created: created})

        multi_struct = Multi.new()
          |> Multi.insert( :persons, person )

        case Repo.transaction(multi_struct) do
          {:ok, _} -> {:ok, nil}
          _ -> {:error, 1}
        end
    end
  end

  def create(_, _, _) do
    {:error, 0}
  end
end
