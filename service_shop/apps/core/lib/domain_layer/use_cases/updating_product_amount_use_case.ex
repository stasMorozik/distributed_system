defmodule Core.DomainLayer.UseCases.UpdatingProductAmountUseCase do
  @moduledoc false

  alias Core.DomainLayer.Ports.UpdatingProductPort

  alias Core.DomainLayer.Ports.GettingProductPort

  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.ValueObjects.Id

  @type t :: Module

  @type ok :: {:ok, true}

  @type error ::
          Id.error()
          | UpdatingProductPort.error()
          | GettingProductPort.error()
          | ProductAggregate.error_updating()

  @type updating_dto :: %{
          amount: integer()
        }

  @callback update(binary(), updating_dto(), GettingProductPort.t(), UpdatingProductPort.t()) :: ok() | error()
end
