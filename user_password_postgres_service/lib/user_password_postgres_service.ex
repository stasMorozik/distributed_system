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
          password -> map_password_to_asoc(password)
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
      password -> map_password_to_asoc(password)
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

  def create_confirming_code(%{
    email: email,
    code: code
  }) when is_binary(email) and is_integer(code) do
    case get_by_email(email) do
      {:ok, _} -> {:error, nil}
      {:error, _} ->
        delete_q = from(c in ConfirmingDataScheme, where: c.email == ^email)
        confirming_data = ConfirmingDataScheme.changeset(%ConfirmingDataScheme{}, %{email: email, code: code, uid: UUID.uuid4()})

        multi_struct = Multi.new()
          |> Multi.delete_all( :delete_confirming_data, delete_q )
          |> Multi.insert(:insert_confirming_data, confirming_data)

        case Repo.transaction(multi_struct) do
          {:ok, _} -> {:ok, nil}
          _ -> {:error, nil}
        end
    end
  end

  def create_confirming_code(_) do
    {:error, nil}
  end

  def get_confirming_code(email) when is_binary(email) do
    query = from c in ConfirmingDataScheme,
      where: c.email == ^email,
      select: c

    case Repo.one(query) do
      nil -> {:error, nil}
      code -> map_code_to_asoc(code)
    end
  end

  def get_confirming_code(_) do
    {:error, nil}
  end

  defp map_code_to_asoc(confirming_code) do
    {
      :ok,
      %{
        code: confirming_code.code,
        email: confirming_code.code
      }
    }
  end

  defp map_password_to_asoc(password) do
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
