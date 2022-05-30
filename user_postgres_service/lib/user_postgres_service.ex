defmodule UserPostgresService do
  import Ecto.Query

  alias Ecto.Multi
  alias Persons.Repo
  alias UserPostgresService.PersonsScheme

  def create(id, name, created) when is_binary(id) and is_binary(name) do
    person = PersonsScheme.changeset(%PersonsScheme{}, %{id: id, name: name, created: created})
    multi_struct = Multi.new()
      |> Multi.insert( :persons, person )

    case Repo.transaction(multi_struct) do
      {:ok, _} -> {:ok, nil}
      _ -> {:error, nil}
    end
  end

  def create(_, _, _) do
    {:error, nil}
  end
end
