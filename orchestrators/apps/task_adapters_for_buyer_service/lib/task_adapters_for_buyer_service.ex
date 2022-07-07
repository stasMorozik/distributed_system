defmodule TaskAdaptersForBuyerService do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingPersonByEmailPort
  alias Core.DomainLayer.Ports.UpdatingBuyerPort
  alias Core.DomainLayer.Ports.CreatingBuyerPort

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @behaviour GettingPersonByEmailPort
  @behaviour CreatingBuyerPort
  @behaviour UpdatingBuyerPort


  @spec get(binary(), binary()) ::
          GettingPersonByEmailPort.ok() | GettingPersonByEmailPort.error()
  def get(email, password) do
    case Node.connect(
           Application.get_env(:task_adapters_for_buyer_service, :service_buyers)[:remote_node]
         ) do
      false ->
        {:error, ServiceUnavailableError.new("Buyer")}

      :ignored ->
        {:error, ServiceUnavailableError.new("Buyer")}

      true ->
        task =
          Task.Supervisor.async(
            Application.get_env(:task_adapters_for_buyer_service, :service_buyers)[
              :remote_supervisor
            ],
            Application.get_env(:task_adapters_for_buyer_service, :service_buyers)[:remote_module],
            :get_by_email,
            [email, password]
          )

        case Task.await(task) do
          {:error, error_dto} ->
            {:error, error_dto}

          {:ok, buyer_entity} ->
            {
              :ok,
              %{
                email: buyer_entity.email.value,
                id: buyer_entity.id.value
              }
            }
        end
    end
  end

  @spec create(CreatingBuyerPort.creating_dto()) ::
          CreatingBuyerPort.ok() | CreatingBuyerPort.error()
  def create(dto) do
    case Node.connect(
           Application.get_env(:task_adapters_for_buyer_service, :service_buyers)[:remote_node]
         ) do
      false ->
        {:error, ServiceUnavailableError.new("Buyer")}

      :ignored ->
        {:error, ServiceUnavailableError.new("Buyer")}

      true ->
        task =
          Task.Supervisor.async(
            Application.get_env(:task_adapters_for_buyer_service, :service_buyers)[
              :remote_supervisor
            ],
            Application.get_env(:task_adapters_for_buyer_service, :service_buyers)[:remote_module],
            :create,
            [dto]
          )

        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end

  @spec update(binary(), UpdatingBuyerPort.updating_dto()) :: UpdatingBuyerPort.ok() | UpdatingBuyerPort.error()
  def update(id, dto) do
    case Node.connect(
           Application.get_env(:task_adapters_for_buyer_service, :service_buyers)[:remote_node]
         ) do
      false ->
        {:error, ServiceUnavailableError.new("Buyer")}

      :ignored ->
        {:error, ServiceUnavailableError.new("Buyer")}

      true ->
        task =
          Task.Supervisor.async(
            Application.get_env(:task_adapters_for_buyer_service, :service_buyers)[
              :remote_supervisor
            ],
            Application.get_env(:task_adapters_for_buyer_service, :service_buyers)[:remote_module],
            :update,
            [id, dto]
          )

        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end
end
