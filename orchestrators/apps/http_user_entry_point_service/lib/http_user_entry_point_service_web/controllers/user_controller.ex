defmodule HttpUserEntryPointServiceWeb.UserController do
  use HttpUserEntryPointServiceWeb, :controller

  alias Core.ApplicationLayer.ConfirmingUserEmailService
  alias Core.ApplicationLayer.RegistrationUserService
  alias Core.DomainLayer.UseCases.AuthenticatingUserService

  alias TaskAdaptersForUserService
  alias TaskAdaptersForConfirmingEmailService
  alias TaskAdaptersForNotifyingService
  alias TaskAdaptersForUserJtwtService

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  def confirm(conn, params) do
    with {:ok, true} <-
           ConfirmingUserEmailService.send_to_email_code(
             params["email"],
             TaskAdaptersForUserService,
             TaskAdaptersForConfirmingEmailService,
             TaskAdaptersForNotifyingService
           ) do
      conn |> put_status(:ok) |> json(true)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def sign_up(conn, params) do
    with {:ok, true} <-
           RegistrationUserService.register(
             %{
               name: params["name"],
               surname: params["surname"],
               email: params["email"],
               phone: params["phone"],
               password: params["password"],
               avatar: params["avatar"],
               code: params["code"]
             },
             TaskAdaptersForConfirmingEmailService,
             TaskAdaptersForUserService
           ) do
      conn |> put_status(:ok) |> json(true)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def sign_in(conn, params) do
    with {:ok, jwt_tokens} <-
           AuthenticatingUserService.authenticate(
             params["email"],
             params["password"],
             TaskAdaptersForUserJtwtService,
             TaskAdaptersForUserService
           ) do
      conn = conn |> put_resp_cookie("token", jwt_tokens[:token])
      conn = conn |> put_resp_cookie("refresh_token", jwt_tokens[:refresh_token])
      conn |> put_status(:ok) |> json(true)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def sign_out(conn, _params) do
    conn = conn |> delete_resp_cookie("token")
    conn = conn |> delete_resp_cookie("refresh_token")
    conn |> put_status(:ok) |> json(:true)
  end
end
