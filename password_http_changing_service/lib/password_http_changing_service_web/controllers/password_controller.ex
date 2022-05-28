defmodule PasswordHttpChangingServiceWeb.PasswordController do
  use PasswordHttpChangingServiceWeb, :controller

  def update_email(conn, params) do
    case Node.connect(remote_node()) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          remote_super(),
          PasswordController,
          :change_email,
          [ params["id"], params["password"], params["new_email"] ]
        )
        case Task.await task do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, password} -> conn |> put_status(:ok) |> json(password)
        end
    end
  end

  def update_password(conn, params) do
    case Node.connect(remote_node()) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          remote_super(),
          PasswordController,
          :change_password,
          [ params["id"], params["password"], params["new_password"] ]
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
