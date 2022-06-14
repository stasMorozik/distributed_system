defmodule UserHttpChangingServiceWeb.ChangingController do
  use UserHttpChangingServiceWeb, :controller

  def change_email(conn, params) do
    case Node.connect(Application.get_env(:user_http_changing_service, :user_controller)[:remote_node]) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:user_http_changing_service, :user_controller)[:remote_supervisor],
          Application.get_env(:user_http_changing_service, :user_controller)[:remote_module],
          :change_email,
          [ conn.req_cookies["token"], params["email"], params["code"] ]
        )
        case Task.await task do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, _} -> conn |> json(:true)
        end
    end
  end
end
