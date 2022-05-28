defmodule UserHttpRegistrationServiceWeb.UserController do
  use UserHttpRegistrationServiceWeb, :controller

  def confirm_password(conn, params) do
    case Node.connect(remote_node()) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          remote_super(),
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

  defp remote_super do
    {PasswordController.TaskSupervisor, remote_node()}
  end

  defp remote_node do
    :password_controller@localhost
  end
end
