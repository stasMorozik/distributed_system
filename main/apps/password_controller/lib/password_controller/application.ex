defmodule PasswordController.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: PasswordController.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: PasswordController.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
