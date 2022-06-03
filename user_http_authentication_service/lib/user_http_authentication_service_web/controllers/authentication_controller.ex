defmodule UserHttpAuthenticationServiceWeb.AuthenticationController do
  use UserHttpAuthenticationServiceWeb, :controller

  def authenticate(conn, params) do
    case Node.connect(Application.get_env(:user_http_authentication_service, :user_controller)[:remote_node]) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:user_http_authentication_service, :user_controller)[:remote_supervisor],
          Application.get_env(:user_http_authentication_service, :user_controller)[:remote_module],
          :authenticate,
          [ params["email"], params["password"] ]
        )
        case Task.await task do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, password} -> conn |> put_status(:ok) |> json(password)
        end
    end
  end
end
