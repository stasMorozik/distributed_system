defmodule HttpBuyerEntryPointServiceWeb.BuyerController do
  use HttpBuyerEntryPointServiceWeb, :controller

  alias Core.ApplicationLayer.ConfirmingPersonEmailService
  alias Core.ApplicationLayer.RegistrationBuyerService
  alias Core.ApplicationLayer.AuthenticatingPersonService
  alias Core.ApplicationLayer.RefreshingJwtService
  alias Core.ApplicationLayer.AuthorizationPersonService
  alias Core.ApplicationLayer.UpdatingPersonEmailService
  alias Core.ApplicationLayer.UpdatingBuyerService

  alias TaskAdaptersForBuyerService
  alias TaskAdaptersForConfirmingEmailService
  alias TaskAdaptersForNotifyingService
  alias TaskAdaptersForBuyerJwtService

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  def confirm_email(conn, params) do
    with {:ok, true} <-
           ConfirmingPersonEmailService.send_to_email_code(
             params["email"],
             TaskAdaptersForBuyerService,
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
           RegistrationBuyerService.register(
             %{
               email: params["email"],
               password: params["password"],
               code: params["code"]
             },
             TaskAdaptersForConfirmingEmailService,
             TaskAdaptersForBuyerService
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
             TaskAdaptersForBuyerJwtService,
             TaskAdaptersForBuyerService
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
             TaskAdaptersForBuyerJwtService
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
    with {:ok, buyer_entity} <-
           AuthorizationPersonService.authorizate(
             conn.req_cookies["token"],
             TaskAdaptersForBuyerJwtService,
             TaskAdaptersForBuyerService
           ) do
      conn |> put_status(:ok) |> json(buyer_entity |> Map.delete(:id))
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
             TaskAdaptersForBuyerJwtService,
             TaskAdaptersForConfirmingEmailService,
             TaskAdaptersForBuyerService
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
           UpdatingBuyerService.update(
             conn.req_cookies["token"],
             %{
               password: params["password"]
             },
             TaskAdaptersForBuyerJwtService,
             TaskAdaptersForBuyerService
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
