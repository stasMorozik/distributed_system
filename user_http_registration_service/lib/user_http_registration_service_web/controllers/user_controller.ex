defmodule UserHttpRegistrationServiceWeb.UserController do
  use UserHttpRegistrationServiceWeb, :controller

  def confirm_password(conn, params) do
    case Node.connect(remote_password_node()) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "Password Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "Password Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          remote_password_super(),
          PasswordController,
          :confirm,
          [ params["id"], params["password"], params["code"] ]
        )
        case Task.await task do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, password} -> conn |> put_status(:ok) |> json(password)
        end
    end
  end

  def register(conn, params) do
    case Node.connect(remote_user_node()) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          remote_user_super(),
          UserController,
          :register,
          [ params["email"], params["password"], params["name"] ]
        )
        case Task.await task do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, password} -> conn |> put_status(:ok) |> json(password)
        end
    end
  end

  defp remote_user_super() do
    {UserController.TaskSupervisor, remote_user_node()}
  end

  defp remote_user_node do
    :user_controller@localhost
  end

  defp remote_password_super do
    {PasswordController.TaskSupervisor, remote_password_node()}
  end

  defp remote_password_node do
    :password_controller@localhost
  end
end
