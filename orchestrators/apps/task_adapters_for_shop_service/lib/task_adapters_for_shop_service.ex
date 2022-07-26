defmodule TaskAdaptersForShopService do
  @moduledoc false

  alias Core.DomainLayer.Ports.CreatingProductPort
  alias Core.DomainLayer.Ports.UpdatingProductPort
  alias Core.DomainLayer.Ports.AddingImageProductPort
  alias Core.DomainLayer.Ports.DeletingImageProductPort
  alias Core.DomainLayer.Ports.LikingProductPort
  alias Core.DomainLayer.Ports.DislikingProductPort
  alias Core.DomainLayer.Ports.GettingProductPort
  alias Core.DomainLayer.Ports.GettingListProductPort
  alias Core.DomainLayer.Ports.CreatingCustomerInvoicePort
  alias Core.DomainLayer.Ports.UpdatingStatusProviderInvoicePort
  alias Core.DomainLayer.Ports.GettingProviderInvoicePort
  alias Core.DomainLayer.Ports.GettingListProviderInvoicePort

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @behaviour CreatingProductPort
  @behaviour UpdatingProductPort
  @behaviour AddingImageProductPort
  @behaviour DeletingImageProductPort
  @behaviour LikingProductPort
  @behaviour DislikingProductPort
  @behaviour GettingProductPort
  @behaviour GettingListProductPort
  @behaviour CreatingCustomerInvoicePort
  @behaviour UpdatingStatusProviderInvoicePort
  @behaviour GettingProviderInvoicePort
  @behaviour GettingListProviderInvoicePort

  @spec create_product(CreatingProductPort.creating_dto()) :: CreatingProductPort.ok() | CreatingProductPort.error()
  def create_product(dto) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :create_product,
          [
            dto
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end

  @spec update_product(
          binary(), UpdatingProductPort.updating_dto()
        ) :: UpdatingProductPort.ok() | UpdatingProductPort.error()
  def update_product(id, dto) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :update_product,
          [
            id,
            dto
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end

  @spec add_image(binary(), list(binary())) :: AddingImageProductPort.ok() | AddingImageProductPort.error()
  def add_image(id, list_image) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :add_image_product,
          [
            id,
            list_image
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end

  @spec delete_image(binary(), binary()) :: DeletingImageProductPort.ok() | DeletingImageProductPort.error()
  def delete_image(id_product, id_image) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :delete_image_product,
          [
            id_product,
            id_image
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end

  @spec like_product(binary(), LikingProductPort.liking_dto()) :: LikingProductPort.ok() | LikingProductPort.error()
  def like_product(id, dto) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :like_product,
          [
            id,
            dto
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end

  @spec dislike_product(
          binary(),
          DislikingProductPort.disliking_dto()
        ) :: DislikingProductPort.ok() | DislikingProductPort.error()
  def dislike_product(id, dto) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :dislike_product,
          [
            id,
            dto
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end

  @spec get_product(binary()) :: GettingProductPort.ok() | GettingProductPort.error()
  def get_product(id) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :get_product,
          [
            id
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, product_entity} ->

            {
              :ok,
              product_from_domain(product_entity)
            }
        end
    end
  end

  @spec get_list_product(
          GettingListProductPort.dto_pagination(),
          GettingListProductPort.dto_sorting()    | nil,
          GettingListProductPort.dto_filtration() | nil,
          GettingListProductPort.dto_spliting()   | nil
        ) :: GettingListProductPort.ok() | GettingListProductPort.error()
  def get_list_product(
    dto_pagination,
    dto_sorting,
    dto_filtration,
    dto_spliting
  ) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :get_list_product,
          [
            dto_pagination,
            dto_sorting,
            dto_filtration,
            dto_spliting
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, product_entities} ->

            {
              :ok,
              product_from_list_domain(product_entities)
            }
        end
    end
  end

  @spec create_invoice(
          CreatingCustomerInvoicePort.creating_dto()
        ) :: CreatingCustomerInvoicePort.ok() | CreatingCustomerInvoicePort.error()
  def create_invoice(dto) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :cretae_customer_invoice,
          [
            dto
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, invoice_entity} ->

            {
              :ok,
              %{
                customer: %{
                  email: invoice_entity.customer.email.value,
                  id: invoice_entity.customer.id.value,
                  created: invoice_entity.customer.created.value,
                },
                number: invoice_entity.number.value,
                invoices:
                  Enum.map(invoice_entity.invoices, fn invoice -> %{
                    provider: %{
                      email: invoice.provider.email.value,
                      id: invoice.provider.id.value,
                      created: invoice.provider.created.value,
                    },
                    number: invoice.number.value,
                  } end)
              }
            }
        end
    end
  end

  @spec update_status_provider_invoice(
          binary()
        ) :: UpdatingStatusProviderInvoicePort.ok() | UpdatingStatusProviderInvoicePort.error()
  def update_status_provider_invoice(id) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :update_provider_invoice_status,
          [
            id
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end

  # @type product :: %{
  #   amount: Amount.t(),
  #   product: ProductAggregate.t()
  # }

  # @type t :: %ProviderInvoiceAggregate{
  #   created: Created.t(),
  #   id: Id.t(),
  #   price: Price.t(),
  #   number: Number.t(),
  #   customer: OwnerEntity.t(),
  #   status: Status.t(),
  #   products: list(product()),
  #   provider: OwnerEntity.t()
  # }

  @spec get_provider_invoice(
          binary()
        ) :: GettingProviderInvoicePort.ok() | GettingProviderInvoicePort.error()
  def get_provider_invoice(id) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :get_provider_invoice,
          [
            id
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, invoice_entity} ->

            {
              :ok,
              provider_invoice_from_domain(invoice_entity)
            }
        end
    end
  end

  @spec get_list_provider_invoice(
          GettingListProviderInvoicePort.dto_pagination(),
          GettingListProviderInvoicePort.dto_sorting()    | nil,
          GettingListProviderInvoicePort.dto_filtration() | nil,
          GettingListProviderInvoicePort.dto_spliting()   | nil
        ) :: GettingListProviderInvoicePort.ok() | GettingListProviderInvoicePort.error()
  def get_list_provider_invoice(
        dto_pagination,
        dto_sorting,
        dto_filtration,
        dto_spliting
      ) do
    case Node.connect(Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Shop")}
      :ignored -> {:error, ServiceUnavailableError.new("Shop")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_supervisor],
          Application.get_env(:task_adapters_for_shop_service, :service_shop)[:remote_module],
          :get_list_provider_invoice,
          [
            dto_pagination,
            dto_sorting,
            dto_filtration,
            dto_spliting
          ]
        )
        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, invoice_entities} ->

            {
              :ok,
              provider_invoice_from_list_domain(invoice_entities)
            }
        end
    end
  end

  defp provider_invoice_from_list_domain(invoice_entities) do
    Enum.map(invoice_entities, fn invoice_entity -> provider_invoice_from_domain(invoice_entity) end)
  end

  defp provider_invoice_from_domain(invoice_entity) do
    %{
      created: invoice_entity.created.value,
      id: invoice_entity.id.value,
      price: invoice_entity.price.value,
      number: invoice_entity.number.value,
      customer: %{
        email: invoice_entity.customer.email.value,
        id: invoice_entity.customer.id.value,
        created: invoice_entity.customer.created.value,
      },
      status: invoice_entity.status.value,
      provider: %{
        email: invoice_entity.provider.email.value,
        id: invoice_entity.provider.id.value,
        created: invoice_entity.provider.created.value,
      },
      products:
        Enum.map(invoice_entity.products, fn product -> %{
          amount: product.amount.value,
          product: product_from_domain(product.product)
        } end)
    }
  end

  defp product_from_list_domain(product_entities) do
    Enum.map(product_entities, fn product_entity -> product_from_domain(product_entity) end)
  end

  defp product_from_domain(product_entity) do
    %{
      id: product_entity.id.value,
      name: product_entity.name.value,
      created: product_entity.created.value,
      amount: product_entity.amount.value,
      ordered: product_entity.ordered.value,
      description: product_entity.description.value,
      price: product_entity.price.value,
      logo: %{
        id: product_entity.logo.id.value,
        created: product_entity.logo.created.value,
        image: Base.encode64(product_entity.logo.image.value)
      },
      images: Enum.map(product_entity.images, fn image_entity -> %{
        id: image_entity.id.value,
        created: image_entity.created.value,
        image: Base.encode64(image_entity.image.value)
      } end),
      likes: Enum.map(product_entity.likes, fn owner_entity -> %{
        email: owner_entity.email.value,
        id: owner_entity.id.value,
        created: owner_entity.created.value,
      } end),
      dislikes: Enum.map(product_entity.dislikes, fn owner_entity -> %{
        email: owner_entity.email.value,
        id: owner_entity.id.value,
        created: owner_entity.created.value,
      } end),
      like_count: product_entity.like_count.value,
      dislike_count: product_entity.dislike_count.value,
      owner: %{
        email: product_entity.owner.email.value,
        id: product_entity.owner.id.value,
        created: product_entity.owner.created.value,
      }
    }
  end
end
