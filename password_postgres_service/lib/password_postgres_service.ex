defmodule PasswordPostgresService do
  import Ecto.Query

  alias Ecto.Multi
  alias PasswordPostgresService.PasswordScheme
  alias PasswordPostgresService.ConfirmingDataScheme

  def get(id) when is_binary(id) do
    case UUID.info(id) do
      {:error, _} -> {:error, nil}
      {:ok, _} ->
        query = from p in PasswordScheme,
          where: p.uid == ^id,
          left_join: c in ConfirmingDataScheme,
          on: c.email == p.email,
          select: {p, c}
        case Passwords.Repo.one(query) do
          nil -> {:error, nil}
          {password, nil} -> map_to_asoc(password)
          {password, confirming_data} -> map_to_asoc_with_code(password, confirming_data)
        end
    end
  end

  def get(_) do
    {:error, nil}
  end

  def change_email(id, new_amil) when is_binary(id) and is_binary(new_amil) do
    case UUID.info(id) do
      {:error, _} -> {:error, nil}
      {:ok, _} ->
        change_set = PasswordScheme.update_email_changeset(%PasswordScheme{uid: id}, %{email: new_amil})
        case Passwords.Repo.transaction(Multi.new() |> Multi.update(:passwords, change_set)) do
          {:ok, _} -> {:ok, nil}
          _ -> {:error, nil}
        end
    end
  end

  def change_email(_, _) do
    {:error, nil}
  end

  defp map_to_asoc(password) do
    {
      :ok,
      %{
        confirmed: password.confirmed,
        created: password.created,
        email: password.email,
        password: password.password,
        id: password.uid
      }
    }
  end

  defp map_to_asoc_with_code(password, confirming_data) do
    {
      :ok,
      %{
        confirmed: password.confirmed,
        created: password.created,
        email: password.email,
        password: password.password,
        id: password.uid
      },
      %{
        code: confirming_data.code
      }
    }
  end

end
