defmodule UserHttpAuthenticatingServiceWeb.AuthenticatingController do
  use UserHttpAuthenticatingServiceWeb, :controller

  def authenticate(conn, params) do
    case Node.connect(Application.get_env(:user_http_authenticating_service, :user_controller)[:remote_node]) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:user_http_authenticating_service, :user_controller)[:remote_supervisor],
          Application.get_env(:user_http_authenticating_service, :user_controller)[:remote_module],
          :authenticate,
          [ params["email"], params["password"] ]
        )
        case Task.await task do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, token} ->
            conn = conn |> put_resp_cookie("token", token)
            conn |> put_status(:ok) |> json(token)
        end
    end
  end

  def logout(conn, _) do
    case Node.connect(Application.get_env(:user_http_authenticating_service, :user_controller)[:remote_node]) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:user_http_authenticating_service, :user_controller)[:remote_supervisor],
          Application.get_env(:user_http_authenticating_service, :user_controller)[:remote_module],
          :logout,
          [ conn.req_cookies["token"] ]
        )
        case Task.await task do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, _} ->
            conn = conn |> delete_resp_cookie("token")
            conn |> put_status(:ok) |> json(:true)
        end
    end
  end
end
