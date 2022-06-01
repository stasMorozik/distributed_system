defmodule UserHttpRegistrationServiceWeb.UserController do
  use UserHttpRegistrationServiceWeb, :controller

  def confirm_password(conn, params) do
    case Node.connect(Application.get_env(:user_http_registration_service, :remote_password_controller_node)) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "Password Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "Password Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:user_http_registration_service, :remote_password_controller_super),
          Application.get_env(:user_http_registration_service, :remote_password_controller_module),
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
    case Node.connect(Application.get_env(:user_http_registration_service, :remote_user_controller_node)) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:user_http_registration_service, :remote_user_controller_super),
          Application.get_env(:user_http_registration_service, :remote_user_controller_module),
          :register,
          [ params["email"], params["password"], params["name"] ]
        )
        case Task.await task do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, password} -> conn |> put_status(:ok) |> json(password)
        end
    end
  end
end
