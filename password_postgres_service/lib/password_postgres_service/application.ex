defmodule PasswordPostgresService.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Passwords.Repo,
      {Task.Supervisor, name: Passwords.Repo.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: PasswordPostgresService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
