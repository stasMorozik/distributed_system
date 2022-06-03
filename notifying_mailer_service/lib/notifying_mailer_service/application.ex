defmodule NotifyingMailerService.Application do

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: NotifyingMailerService.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: NotifyingMailerService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
