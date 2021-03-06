defmodule Core.ApplicationLayer.CreatingService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.CreatingUseCase
  alias Core.DomainLayer.ConfirmingCodeEntity
  alias Core.DomainLayer.Ports.GettingPort
  alias Core.DomainLayer.Ports.UpdatingPort
  alias Core.DomainLayer.Ports.CreatingPort
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.Errors.InfrastructureError

  @spec create(
          binary(),
          GettingPort.t(),
          UpdatingPort.t(),
          CreatingPort.t()
        ) :: CreatingUseCase.ok() | CreatingUseCase.error()
  def create(maybe_email, getting_port, updating_port, creating_port) do
    with {:ok, value_email} <- Email.new(maybe_email),
         {:ok, code_entity} <- getting_port.get(value_email),
         {:ok, code_entity} <- ConfirmingCodeEntity.from_origin(code_entity),
         {:ok, true} <- updating_port.update(code_entity) do
      {:ok, code_entity}
    else
      {:error, %InfrastructureError{message: "Code not found"}} ->
        with {:ok, code_entity} <- ConfirmingCodeEntity.new(maybe_email),
             {:ok, true} <- creating_port.create(code_entity) do
          {:ok, code_entity}
        else
          {:error, error_dto} -> {:error, error_dto}
        end

      {:error, error_dto} ->
        {:error, error_dto}
    end
  end
end
