defmodule TaskAdaptersForConfirmingEmailService do
  @moduledoc false

  alias Core.DomainLayer.Ports.CreatingConfirmingCodePort
  alias Core.DomainLayer.Ports.ValidatingConfirmingCodePort

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @behaviour CreatingConfirmingCodePort
  @behaviour ValidatingConfirmingCodePort

  @spec create(binary()) :: CreatingConfirmingCodePort.ok() | CreatingConfirmingCodePort.error()
  def create(email) do
    case Node.connect(Application.get_env(:task_adapters_for_confirming_email_service, :service_confirming_email)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Confirming Email")}
      :ignored -> {:error, ServiceUnavailableError.new("Confirming Email")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_confirming_email_service, :service_confirming_email)[:remote_supervisor],
          Application.get_env(:task_adapters_for_confirming_email_service, :service_confirming_email)[:remote_module],
          :create,
          [ email ]
        )
        case Task.await task do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, code_entity} -> {:ok, code_entity}
        end
    end
  end

  @spec validate(binary(), integer()) :: ValidatingConfirmingCodePort.ok() | ValidatingConfirmingCodePort.error()
  def validate(email, code) do
    case Node.connect(Application.get_env(:task_adapters_for_confirming_email_service, :service_confirming_email)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Confirming Email")}
      :ignored -> {:error, ServiceUnavailableError.new("Confirming Email")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_confirming_email_service, :service_confirming_email)[:remote_supervisor],
          Application.get_env(:task_adapters_for_confirming_email_service, :service_confirming_email)[:remote_module],
          :validate,
          [ email, code ]
        )
        case Task.await task do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end
end
