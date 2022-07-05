defmodule TaskAdaptersForUserJtwtService do
  @moduledoc false

  alias Core.DomainLayer.Ports.CreatingJwtPort

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @behaviour CreatingJwtPort

  @spec create(binary(), binary()) :: CreatingJwtPort.ok() | CreatingJwtPort.error()
  def create(email, hash_password) do
    case Node.connect(Application.get_env(:task_adapters_for_user_jtwt_service, :service_jwt)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("JWT")}
      :ignored -> {:error, ServiceUnavailableError.new("JWT")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_user_jtwt_service, :service_jwt)[:remote_supervisor],
          Application.get_env(:task_adapters_for_user_jtwt_service, :service_jwt)[:remote_module],
          :create,
          [
            email,
            hash_password,
            Application.get_env(:task_adapters_for_user_jtwt_service, :service_jwt)[:secret_key],
            Application.get_env(:task_adapters_for_user_jtwt_service, :service_jwt)[:secret_ex_key]
          ]
        )
        case Task.await task do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, jwt_entity} -> {:ok, jwt_entity}
        end
    end
  end
end
