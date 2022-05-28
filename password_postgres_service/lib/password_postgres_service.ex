defmodule PasswordPostgresService do
  import Ecto.Query

  alias Ecto.Multi
  alias PasswordPostgresService.PasswordScheme
  alias PasswordPostgresService.ConfirmingDataScheme
  alias Passwords.Repo

  def get(id) when is_binary(id) do
    case UUID.info(id) do
      {:error, _} -> {:error, nil}
      {:ok, _} ->
        query = from p in PasswordScheme,
          where: p.uid == ^id,
          left_join: c in ConfirmingDataScheme,
          on: c.email == p.email,
          select: {p, c}
        case Repo.one(query) do
          nil -> {:error, nil}
          {password, nil} -> map_to_asoc(password)
          {password, confirming_data} -> map_to_asoc_with_code(password, confirming_data)
        end
    end
  end

  def get(_) do
    {:error, nil}
  end

  def get_by_email(email) when is_binary(email) do
    query = from p in PasswordScheme,
      where: p.email == ^email,
      left_join: c in ConfirmingDataScheme,
      on: c.email == p.email,
      select: {p, c}

    case Repo.one(query) do
      nil -> {:error, nil}
      {password, nil} -> map_to_asoc(password)
      {password, confirming_data} -> map_to_asoc_with_code(password, confirming_data)
    end

  end

  def get_by_email(_) do
    {:error, nil}
  end

  def change_email(id, new_amil) when is_binary(id) and is_binary(new_amil) do
    case UUID.info(id) do
      {:error, _} -> {:error, nil}
      {:ok, _} ->
        change_set = PasswordScheme.update_email_changeset(%PasswordScheme{uid: id}, %{email: new_amil})
        case Repo.transaction(Multi.new() |> Multi.update(:passwords, change_set)) do
          {:ok, _} -> {:ok, nil}
          _ -> {:error, nil}
        end
    end
  end

  def change_email(_, _) do
    {:error, nil}
  end

  def change_password(id, new_password) when is_binary(id) and is_binary(new_password) do
    case UUID.info(id) do
      {:error, _} -> {:error, nil}
      {:ok, _} ->
        update_q = from(p in PasswordScheme, where: p.uid == ^id)

        multi_struct = Multi.new()
          |> Multi.update_all( :passwords, update_q, set: [password: new_password] )

        case Repo.transaction(multi_struct) do
          {:ok, _} -> {:ok, nil}
          _ -> {:error, nil}
        end
    end
  end

  def confirm(id, email, confirmed_code) when is_binary(id) and is_binary(email) and is_integer(confirmed_code) do
    case UUID.info(id) do
      {:error, _} -> {:error, nil}
      {:ok, _} ->
        update_q = from(p in PasswordScheme, where: p.uid == ^id)
        delete_q = from(c in ConfirmingDataScheme, where: c.email == ^email, where: c.code == ^confirmed_code)

        multi_struct = Multi.new()
          |> Multi.update_all( :passwords, update_q, set: [confirmed: :true] )
          |> Multi.delete_all( :confirming_data, delete_q )

        case Repo.transaction(multi_struct) do
          {:ok, _} -> {:ok, nil}
          _ -> {:error, nil}
        end
    end
  end

  def confirm(_, _, _) do
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
