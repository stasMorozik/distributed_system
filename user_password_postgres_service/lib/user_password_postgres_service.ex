defmodule UserPasswordPostgresService do
  import Ecto.Query

  alias Ecto.Multi
  alias UserPasswordPostgresService.PasswordScheme
  alias UserPasswordPostgresService.ConfirmingDataScheme
  alias Passwords.Repo

  def get(id) when is_binary(id) do
    case UUID.info(id) do
      {:error, _} -> {:error, nil}
      {:ok, _} ->
        query = from p in PasswordScheme,
          where: p.uid == ^id,
          select: p
        case Repo.one(query) do
          nil -> {:error, nil}
          password -> map_to_asoc(password)
        end
    end
  end

  def get(_) do
    {:error, nil}
  end

  def get_by_email(email) when is_binary(email) do
    query = from p in PasswordScheme,
      where: p.email == ^email,
      select: p

    case Repo.one(query) do
      nil -> {:error, nil}
      password -> map_to_asoc(password)
    end
  end

  def get_by_email(_) do
    {:error, nil}
  end

  def create(%{
    id: id,
    password: password,
    email: email,
    confirmed: confirmed,
    created: created
  }) when
    is_binary(id) and
    is_binary(password) and
    is_binary(email) and
    is_boolean(confirmed) do

      case UUID.info(id) do
        {:error, _} -> {:error, nil}
        {:ok, _} ->
          pswd = PasswordScheme.changeset(%PasswordScheme{}, %{uid: id, password: password, confirmed: confirmed, email: email, created: created})
          multi_struct = Multi.new()
            |> Multi.insert(:passwords, pswd)

          case Passwords.Repo.transaction(multi_struct) do
            {:ok, _} -> {:ok, nil}
            _ -> {:error, nil}
          end
      end
  end

  def create(_) do
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

end
