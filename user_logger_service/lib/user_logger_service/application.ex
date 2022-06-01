defmodule UserLoggerService.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: UserLoggerService.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: UserLoggerService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
