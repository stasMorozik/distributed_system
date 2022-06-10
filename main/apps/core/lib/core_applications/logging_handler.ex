defmodule Core.CoreApplications.LoggingHandler do
  alias Jason, as: JSON
  alias Core.CoreDomains.Common.Dtos.ImpossibleCallError

  alias Core.CoreDomains.Common.Ports.Notifying

  defmacro __using__(opts) do
    some_command = Keyword.get(opts, :command, "SomeCommand")
    remote_node = Keyword.get(opts, :remote_node, :remote_node)
    remote_supervisor = Keyword.get(opts, :remote_supervisor, :remote_supervisor)
    remote_module = Keyword.get(opts, :remote_module, :remote_module)

    quote do

      def handler_error(command, %ImpossibleCallError{message: message}, admin_notifying_port) do
        some_command = unquote(some_command)
        case JSON.encode(Map.from_struct(command)) do
          {:ok, json} ->
            error("Node - #{node()}. #{some_command} - #{json}. Error - #{message}")
            admin_notifying_port.notify("@MyComapnyDev", "Error", "Node - #{node()}. Error - #{message}")
          {:error, _} ->
            error("Node - #{node()}. Error - #{message}")
            admin_notifying_port.notify("@MyComapnyDev", "Error", "Node - #{node()}. Error - #{message}")
        end
      end

      def handler_error(command, some_error_dto, _) do
        some_command = unquote(some_command)
        case JSON.encode(Map.from_struct(command)) do
          {:ok, json} ->
            info("Node - #{node()}. #{some_command} - #{json}. Error - #{some_error_dto.message}")
          {:error, _} ->
            error("Node - #{node()}. Error - #{some_error_dto.message}")
        end
      end

      def handle_success(command) do
        some_command = unquote(some_command)
        case JSON.encode(Map.from_struct(command)) do
          {:ok, json} -> info("Node - #{node()}. #{some_command} - #{json}. Ok.")
          {:error, e} -> error("NOde - #{node()} #{e}. Ok.")
        end
      end

      defp info(message) do
        case connect_to_remote_node() do
          :true -> send_to_loger_service(:info, node(), message)
          _ -> Logger.info(message)
        end
      end

      defp error(message) do
        case connect_to_remote_node() do
          :true -> send_to_loger_service(:error, node(), message)
          _ -> Logger.error(message)
        end
      end

      defp connect_to_remote_node do
        remote_node = unquote(remote_node)
        Node.connect(remote_node)
      end

      defp send_to_loger_service(type, from_node, message) do
        remote_supervisor = unquote(remote_supervisor)
        remote_module = unquote(remote_module)

        Task.Supervisor.async(
          remote_supervisor,
          remote_module,
          :log,
          [ type, from_node, message ]
        )
      end

    end

  end

end
