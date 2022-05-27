defmodule PasswordHttpChangingServiceWeb.PasswordController do
  use PasswordHttpChangingServiceWeb, :controller

  def update_email(conn, params) do
    case Node.connect(:controllers@localhost) do
      :false -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :ignored -> conn |> put_status(:service_unavailable) |> json(%{message: "Controller Service Unavailable"})
      :true ->
        case Task.Supervisor.async(
          {Controllers.TaskSupervisor, :controllers@localhost},
          Controllers.Password.Controller,
          :change_email,
          [ params["id"], params["password"], params["new_email"] ]
        ) |> Task.await() do
          {:error, dto} -> conn |> put_status(:bad_request) |> json(dto)
          {:ok, password} -> conn |> put_status(:ok) |> json(password)
        end
    end
  end
end
