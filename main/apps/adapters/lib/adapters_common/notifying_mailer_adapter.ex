defmodule Adapters.AdaptersCommon.NotifyingMailerAdapter do
  alias Core.CoreDomains.Common.Ports.Notifying

  @behaviour Notifying

  @spec notify(binary, binary, binary) :: any()
  def notify(address, subject, message) when
  is_binary(address) and
  is_binary(subject) and
  is_binary(message) do
    case Node.connect(Application.get_env(:adapters, :notifying_mailer_service)[:remote_node]) do
      :true ->
        case generate_task(address, subject, message) |> Task.await() do
          {:ok, _} -> {:ok, nil}
          {:error, _} -> {:error, nil}
        end
      _ -> {:error, nil}
    end
  end

  def notify(_, _, _) do
    {:error, nil}
  end

  defp generate_task(address, subject, message) do
    Task.Supervisor.async(
      Application.get_env(:adapters, :notifying_mailer_service)[:remote_supervisor],
      Application.get_env(:adapters, :notifying_mailer_service)[:remote_module],
      :notify,
      [address, subject, message]
    )
  end
end
