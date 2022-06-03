defmodule Core.CoreApplications.User.Logger do
  require Logger

  def info(message) do
    case connect_to_remote_node() do
      :true -> send_to_loger_service(:info, node(), message)
      _ -> Logger.info(message)
    end
  end

  def error(message) do
    case connect_to_remote_node() do
      :true -> send_to_loger_service(:error, node(), message)
      _ -> Logger.error(message)
    end
  end

  defp connect_to_remote_node do
    Node.connect(Application.get_env(:core, :logger_user_service)[:remote_node])
  end

  defp send_to_loger_service(type, from_node, message) do
    Task.Supervisor.async(
      Application.get_env(:core, :logger_user_service)[:remote_supervisor],
      Application.get_env(:core, :logger_user_service)[:remote_module],
      :log,
      [ type, from_node, message ]
    )
  end
end
