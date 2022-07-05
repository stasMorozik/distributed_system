defmodule TaskAdaptersForNotifyingService do
  @moduledoc false

  alias Core.DomainLayer.Ports.NotifyingMailPort
  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @behaviour NotifyingMailPort

  @spec send_mail(binary(), binary(), binary(), binary()) :: NotifyingMailPort.ok() | NotifyingMailPort.error()
  def send_mail(from, to, subject, message) do
    case Node.connect(Application.get_env(:task_adapters_for_notifying_service, :service_notifying)[:remote_node]) do
      :false -> {:error, ServiceUnavailableError.new("Notifying")}
      :ignored -> {:error, ServiceUnavailableError.new("Notifying")}
      :true ->
        task = Task.Supervisor.async(
          Application.get_env(:task_adapters_for_notifying_service, :service_notifying)[:remote_supervisor],
          Application.get_env(:task_adapters_for_notifying_service, :service_notifying)[:remote_module],
          :send_mail,
          [ from, to, subject, message ]
        )
        case Task.await task do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end
end
