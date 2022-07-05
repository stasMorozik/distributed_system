defmodule TaskAdaptersForUserService do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingUserByEmailPort
  alias Core.DomainLayer.Ports.CreatingUserPort

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @behaviour GettingUserByEmailPort
  @behaviour CreatingUserPort

  @spec get(binary(), binary()) :: GettingUserByEmailPort.ok() | GettingUserByEmailPort.error()
  def get(email, password) do
    case Node.connect(
           Application.get_env(:task_adapters_for_user_service, :service_users)[:remote_node]
         ) do
      false ->
        {:error, ServiceUnavailableError.new("User")}

      :ignored ->
        {:error, ServiceUnavailableError.new("User")}

      true ->
        task =
          Task.Supervisor.async(
            Application.get_env(:task_adapters_for_user_service, :service_users)[
              :remote_supervisor
            ],
            Application.get_env(:task_adapters_for_user_service, :service_users)[:remote_module],
            :get_by_email,
            [email, password]
          )

        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, user_entity} -> {:ok, user_entity}
        end
    end
  end

  @callback create(CreatingUserPort.creating_dto()) ::
              CreatingUserPort.ok() | CreatingUserPort.error()
  def create(dto) do
    case Node.connect(
           Application.get_env(:task_adapters_for_user_service, :service_users)[:remote_node]
         ) do
      false ->
        {:error, ServiceUnavailableError.new("User")}

      :ignored ->
        {:error, ServiceUnavailableError.new("User")}

      true ->
        task =
          Task.Supervisor.async(
            Application.get_env(:task_adapters_for_user_service, :service_users)[
              :remote_supervisor
            ],
            Application.get_env(:task_adapters_for_user_service, :service_users)[:remote_module],
            :create,
            [dto]
          )

        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end
end
