defmodule TaskAdaptersForUserService do
  @moduledoc false

  alias Core.DomainLayer.Ports.GettingPersonByEmailPort
  alias Core.DomainLayer.Ports.CreatingUserPort
  alias Core.DomainLayer.Ports.UpdatingUserPort

  alias Core.DomainLayer.Dtos.ServiceUnavailableError

  @behaviour GettingPersonByEmailPort
  @behaviour CreatingUserPort
  @behaviour UpdatingUserPort

  @spec get(binary(), binary()) ::
          GettingPersonByEmailPort.ok() | GettingPersonByEmailPort.error()
  def get(email, password) do
    case Node.connect(
           Application.get_env(:task_adapters_for_user_service, :service_users)[:remote_node]
         ) do
      false ->
        {:error, ServiceUnavailableError.new("User")}

      :ignored ->
        {:error, ServiceUnavailableError.new("User")}

      true ->
        task =
          Task.Supervisor.async(
            Application.get_env(:task_adapters_for_user_service, :service_users)[
              :remote_supervisor
            ],
            Application.get_env(:task_adapters_for_user_service, :service_users)[:remote_module],
            :get_by_email,
            [email, password]
          )

        case Task.await(task) do
          {:error, error_dto} ->
            {:error, error_dto}

          {:ok, user_entity} ->
            {
              :ok,
              %{
                name: user_entity.name.value,
                surname: user_entity.surname.value,
                email: user_entity.email.value,
                phone: user_entity.phone.value,
                id: user_entity.id.value,
                avatar: Base.encode64(user_entity.avatar.value)
              }
            }
        end
    end
  end

  @spec create(CreatingUserPort.creating_dto()) ::
          CreatingUserPort.ok() | CreatingUserPort.error()
  def create(dto) do
    case Node.connect(
           Application.get_env(:task_adapters_for_user_service, :service_users)[:remote_node]
         ) do
      false ->
        {:error, ServiceUnavailableError.new("User")}

      :ignored ->
        {:error, ServiceUnavailableError.new("User")}

      true ->
        task =
          Task.Supervisor.async(
            Application.get_env(:task_adapters_for_user_service, :service_users)[
              :remote_supervisor
            ],
            Application.get_env(:task_adapters_for_user_service, :service_users)[:remote_module],
            :create,
            [dto]
          )

        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end

  @spec update(binary(), UpdatingUserPort.updating_dto()) :: UpdatingUserPort.ok() | UpdatingUserPort.error()
  def update(id, dto) do
    case Node.connect(
           Application.get_env(:task_adapters_for_user_service, :service_users)[:remote_node]
         ) do
      false ->
        {:error, ServiceUnavailableError.new("User")}

      :ignored ->
        {:error, ServiceUnavailableError.new("User")}

      true ->
        task =
          Task.Supervisor.async(
            Application.get_env(:task_adapters_for_user_service, :service_users)[
              :remote_supervisor
            ],
            Application.get_env(:task_adapters_for_user_service, :service_users)[:remote_module],
            :update,
            [id, dto]
          )

        case Task.await(task) do
          {:error, error_dto} -> {:error, error_dto}
          {:ok, bool} -> {:ok, bool}
        end
    end
  end
end
