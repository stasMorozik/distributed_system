defmodule HttpShopEntryPointServiceWeb.Router do
  use HttpShopEntryPointServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HttpShopEntryPointServiceWeb do
    pipe_through :api

    post "/create-product", ShopController, :product_create
    get "/get-list-products", ShopController, :products
    put "/update-product/:id", ShopController, :product_update
    post "/add-image-product/:id", ShopController, :add_image_product
    delete "/delete-image-product/:id_product/image/:id_image", ShopController, :delete_image_product
    post "/add-like-product/:id", ShopController, :add_like_product
    post "/add-dislike-product/:id", ShopController, :add_dislike_product
    get "/get-product/:id", ShopController, :product

    post "/create-invoice", ShopController, :invoice_create
    put "/update-invoice/:id", ShopController, :invoice_update
    get "/get-list-provider-invoices", ShopController, :provider_invoices
    get "/get-provider-invoice/:id", ShopController, :provider_invoice
    get "/get-list-customer-invoices", ShopController, :customer_invoices
    get "/get-customer-invoice/:id", ShopController, :customer_invoice
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: HttpShopEntryPointServiceWeb.Telemetry
    end
  end
end
