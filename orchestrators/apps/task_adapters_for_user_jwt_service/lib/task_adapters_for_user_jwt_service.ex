defmodule TaskAdaptersForUserJwtService do
  @moduledoc false

  alias Core.DomainLayer.Ports.CreatingJwtPort
  alias Core.DomainLayer.Ports.RefreshingJwtPort
  alias Core.DomainLayer.Ports.ParsingJwtPort

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @behaviour CreatingJwtPort
  @behaviour RefreshingJwtPort
  @behaviour ParsingJwtPort

  @spec create(binary(), binary(), binary()) :: CreatingJwtPort.ok() | CreatingJwtPort.error()
  def create(email, password, id) do
    case Node.connect(Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("JWT")}
      :ignored -> {:error, ServiceUnavailableError.new("JWT")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:remote_supervisor],
          Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:remote_module],
          :create,
          [
            email,
            password,
            id,
            Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:secret_key],
            Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:secret_ex_key]
          ]
        )
        case Task.await task do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, jwt_entity} -> {:ok, jwt_entity}
        end
    end
  end

  @spec refresh(binary()) :: RefreshingJwtPort.ok() | RefreshingJwtPort.error()
  def refresh(refresh_token) do
    case Node.connect(Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("JWT")}
      :ignored -> {:error, ServiceUnavailableError.new("JWT")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:remote_supervisor],
          Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:remote_module],
          :refresh,
          [
            refresh_token,
            Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:secret_key],
            Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:secret_ex_key]
          ]
        )
        case Task.await task do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, jwt_entity} -> {:ok, jwt_entity}
        end
    end
  end

  @spec parse(binary()) :: ParsingJwtPort.ok() | ParsingJwtPort.error()
  def parse(token) do
    case Node.connect(Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("JWT")}
      :ignored -> {:error, ServiceUnavailableError.new("JWT")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:remote_supervisor],
          Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:remote_module],
          :parse,
          [
            token,
            Application.get_env(:task_adapters_for_user_jwt_service, :service_jwt)[:secret_key]
          ]
        )
        case Task.await task do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, jwt_entity} -> {:ok, jwt_entity}
        end
    end
  end
end
