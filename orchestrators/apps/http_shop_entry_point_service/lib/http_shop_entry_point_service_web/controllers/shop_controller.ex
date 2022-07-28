defmodule HttpShopEntryPointServiceWeb.ShopController do
  use HttpShopEntryPointServiceWeb, :controller

  alias Core.ApplicationLayer.CreatingProductService
  alias Core.ApplicationLayer.GettingListProductService
  alias Core.ApplicationLayer.UpdatingProductService
  alias Core.ApplicationLayer.AddingImageProductService
  alias Core.ApplicationLayer.DeletingImageProductService
  alias Core.ApplicationLayer.LikingProductService
  alias Core.ApplicationLayer.DislikingProductService
  alias Core.ApplicationLayer.GettingProductService
  alias Core.ApplicationLayer.CreatingCustomerInvoiceService
  alias Core.ApplicationLayer.UpdatingStatusProviderInvoiceService
  alias Core.ApplicationLayer.GettingListProviderInvoiceService
  alias Core.ApplicationLayer.GettingProviderInvoiceService
  alias Core.ApplicationLayer.GettingListCustomerInvoiceService
  alias Core.ApplicationLayer.GettingCustomerInvoiceService

  alias TaskAdaptersForUserJwtService
  alias TaskAdaptersForBuyerJwtService
  alias TaskAdaptersForShopService
  alias TaskAdaptersForNotifyingService

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  def product_create(conn, params) do
    with {:ok, true} <-
      CreatingProductService.create(
        conn.req_cookies["token"],
        %{
          name: params["name"],
          amount: params["amount"],
          description: params["description"],
          price: params["price"],
          logo: params["logo"],
          images: params["images"],
        },
        TaskAdaptersForUserJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(true)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def products(conn, params) do
    with {:ok, list_product} <-
      GettingListProductService.get(
        %{
          offset: params["offset"],
          limit: params["limit"],
        },
        %{
          type: params["type_sort"],
          value: params["value_sort"],
        },
        %{
          provider: params["provider"],
          name: params["name"],
        },
        %{
          value: params["value_split"]
        },
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(list_product)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def product(conn, params) do
    with {:ok, product} <-
      GettingProductService.get(
        params["id"],
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(product)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def product_update(conn, params) do
    with {:ok, true} <-
      UpdatingProductService.update(
        conn.req_cookies["token"],
        params["id"],
        %{
          name: params["name"],
          amount: params["amount"],
          description: params["description"],
          price: params["price"],
          logo: params["logo"]
        },
        TaskAdaptersForUserJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(true)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def add_image_product(conn, params) do
    with {:ok, true} <-
      AddingImageProductService.add(
        conn.req_cookies["token"],
        params["id"],
        params["images"],
        TaskAdaptersForUserJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(true)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def delete_image_product(conn, params) do
    with {:ok, true} <-
      DeletingImageProductService.delete(
        conn.req_cookies["token"],
        params["id_product"],
        params["id_image"],
        TaskAdaptersForUserJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(true)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def add_like_product(conn, params) do
    with {:ok, true} <-
      LikingProductService.like(
        conn.req_cookies["token"],
        params["id"],
        TaskAdaptersForBuyerJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(true)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def add_dislike_product(conn, params) do
    with {:ok, true} <-
      DislikingProductService.dislike(
        conn.req_cookies["token"],
        params["id"],
        TaskAdaptersForBuyerJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(true)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def invoice_create(conn, params) do
    with {:ok, true} <-
      CreatingCustomerInvoiceService.create(
        conn.req_cookies["token"],
        params["products"],
        TaskAdaptersForBuyerJwtService,
        TaskAdaptersForShopService,
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

  def invoice_update(conn, params) do
    with {:ok, true} <-
      UpdatingStatusProviderInvoiceService.update(
        conn.req_cookies["token"],
        params["id"],
        TaskAdaptersForUserJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(true)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def provider_invoices(conn, params) do
    with {:ok, list_invoice} <-
      GettingListProviderInvoiceService.get(
        conn.req_cookies["token"],
        %{
          offset: params["offset"],
          limit: params["limit"],
        },
        %{
          type: params["type_sort"],
          value: params["value_sort"],
        },
        %{
          customer: params["customer"],
        },
        %{
          value: params["value_split"]
        },
        TaskAdaptersForUserJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(list_invoice)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def provider_invoice(conn, params) do
    with {:ok, invoice} <-
      GettingProviderInvoiceService.get(
        conn.req_cookies["token"],
        params["id"],
        TaskAdaptersForUserJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(invoice)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def customer_invoices(conn, params) do
    with {:ok, list_invoice} <-
      GettingListCustomerInvoiceService.get(
        conn.req_cookies["token"],
        %{
          offset: params["offset"],
          limit: params["limit"],
        },
        %{
          type: params["type_sort"],
          value: params["value_sort"],
        },
        %{
          provider: params["provider"]
        },
        %{
          value: params["value_split"]
        },
        TaskAdaptersForBuyerJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(list_invoice)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end

  def customer_invoice(conn, params) do
    with {:ok, invoice} <-
      GettingCustomerInvoiceService.get(
        conn.req_cookies["token"],
        params["id"],
        TaskAdaptersForBuyerJwtService,
        TaskAdaptersForShopService
      ) do
      conn |> put_status(:ok) |> json(invoice)
    else
      {:error, %ServiceUnavailableError{message: m}} ->
        conn |> put_status(:service_unavailable) |> json(%{message: m})

      {:error, error_dto} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(error_dto))
    end
  end
end
