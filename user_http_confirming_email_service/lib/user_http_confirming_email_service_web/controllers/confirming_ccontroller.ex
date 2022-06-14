defmodule UserHttpConfirmingEmailServiceWeb.ConfirmingController do
  use UserHttpConfirmingEmailServiceWeb, :controller

  def confirm(conn, params) do
    case Node.connect(Application.get_env(:user_http_confirming_email_service, :user_controller)[:remote_node]) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "User Controller Service Unavailable"})
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:user_http_confirming_email_service, :user_controller)[:remote_supervisor],
          Application.get_env(:user_http_confirming_email_service, :user_controller)[:remote_module],
          :confrim_email,
          [ params["email"] ]
        )
        case Task.await task do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, some} -> conn |> put_status(:ok) |> json(some)
        end
    end
  end
end
