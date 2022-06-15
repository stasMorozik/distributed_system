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
  # def create(id, name, surname, created) when is_binary(id) and is_binary(name) and is_binary(surname) do
  #   case UUID.info(id) do
  #     {:error, _} -> {:error, nil}
  #     {:ok, _} ->
  #       person = PersonsScheme.changeset(%PersonsScheme{}, %{id: id, name: name, surname: surname, created: created})

  #       multi_struct = Multi.new()
  #         |> Multi.insert( :persons, person )

  #       case Repo.transaction(multi_struct) do
  #         {:ok, _} -> {:ok, nil}
  #         _ -> {:error, nil}
  #       end
  #   end
  # end

  # def create(_, _, _, _) do
  #   {:error, nil}
  # end
end
