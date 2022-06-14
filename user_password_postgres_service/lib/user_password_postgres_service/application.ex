defmodule UserPasswordPostgresService.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Passwords.Repo,
      {Task.Supervisor, name: UserPasswordPostgresService.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: UserPasswordPostgresService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
