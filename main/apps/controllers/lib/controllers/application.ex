defmodule Controllers.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Controllers.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Controllers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
