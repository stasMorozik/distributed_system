defmodule UserPostgresService.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Persons.Repo,
      {Task.Supervisor, name: Persons.Repo.TaskSupervisor}
    ]


    opts = [strategy: :one_for_one, name: UserPostgresService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
