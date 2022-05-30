defmodule UserController.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: UserController.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: UserController.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
