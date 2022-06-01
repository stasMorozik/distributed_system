defmodule PasswordHttpChangingServiceWeb.PasswordController do
  use PasswordHttpChangingServiceWeb, :controller

  def update_email(conn, params) do
    case Node.connect(Application.get_env(:password_http_changing_service, :remote_password_controller_node)) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:password_http_changing_service, :remote_password_controller_super),
          Application.get_env(:password_http_changing_service, :remote_password_controller_module),
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
    case Node.connect(Application.get_env(:password_http_changing_service, :remote_password_controller_node)) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:password_http_changing_service, :remote_password_controller_super),
          Application.get_env(:password_http_changing_service, :remote_password_controller_module),
          :change_password,
          [ params["id"], params["password"], params["new_password"] ]
        )
        case Task.await task do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, password} -> conn |> put_status(:ok) |> json(password)
        end
    end
  end
end
