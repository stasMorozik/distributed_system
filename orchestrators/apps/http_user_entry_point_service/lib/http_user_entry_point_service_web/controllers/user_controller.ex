defmodule HttpUserEntryPointServiceWeb.UserController do
  use HttpUserEntryPointServiceWeb, :controller

  alias Core.ApplicationLayer.ConfirmingPersonEmailService
  alias Core.ApplicationLayer.RegistrationUserService
  alias Core.ApplicationLayer.AuthenticatingPersonService
  alias Core.ApplicationLayer.RefreshingJwtService
  alias Core.ApplicationLayer.AuthorizationPersonService
  alias Core.ApplicationLayer.UpdatingPersonEmailService
  alias Core.ApplicationLayer.UpdatingUserService

  alias TaskAdaptersForUserService
  alias TaskAdaptersForConfirmingEmailService
  alias TaskAdaptersForNotifyingService
  alias TaskAdaptersForUserJwtService

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  def confirm_email(conn, params) do
    with {:ok, true} <-
           ConfirmingPersonEmailService.send_to_email_code(
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
           AuthenticatingPersonService.authenticate(
             params["email"],
             params["password"],
             TaskAdaptersForUserJwtService,
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
    conn |> put_status(:ok) |> json(true)
  end

  def refresh_token(conn, _params) do
    with {:ok, jwt_tokens} <-
           RefreshingJwtService.refresh(
             conn.req_cookies["refresh_token"],
             TaskAdaptersForUserJwtService
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

  def get(conn, _params) do
    with {:ok, user_entity} <-
           AuthorizationPersonService.authorizate(
             conn.req_cookies["token"],
             TaskAdaptersForUserJwtService,
             TaskAdaptersForUserService
           ) do
      conn |> put_status(:ok) |> json(user_entity |> Map.delete(:id))
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def update_email(conn, params) do
    with {:ok, _} <-
           UpdatingPersonEmailService.update(
             conn.req_cookies["token"],
             %{email: params["email"], code: params["code"]},
             TaskAdaptersForUserJwtService,
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

  def update(conn, params) do
    with {:ok, _} <-
           UpdatingUserService.update(
             conn.req_cookies["token"],
             %{
               name: params["name"],
               surname: params["surname"],
               phone: params["phone"],
               password: params["password"],
               avatar: params["avatar"]
             },
             TaskAdaptersForUserJwtService,
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
end
