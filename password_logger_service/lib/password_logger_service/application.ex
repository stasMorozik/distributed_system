defmodule PasswordLoggerService.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: PasswordLoggerService.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: PasswordLoggerService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
