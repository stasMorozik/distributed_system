defmodule Core.ApplicationLayer.SendMailservice do
  @moduledoc false

  alias Core.DomainLayer.UseCases.SendMailUseCase

  alias Core.DomainLayer.Ports.SendMailPort

  alias Core.DomainLayer.NotificationEntity

  @behaviour SendMailUseCase

  @spec send(binary(), binary(), binary(), binary(), SendMailPort.t()) ::
          SendMailUseCase.ok() | SendMailUseCase.error()
  def send(from, to, subject, mess, send_mail_port) do
    with {:ok, notification_entity} <- NotificationEntity.new_for_email(from, to, subject, mess),
         {:ok, true} <- send_mail_port.send(notification_entity) do
      {:ok, true}
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
