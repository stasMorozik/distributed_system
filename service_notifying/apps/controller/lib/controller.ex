defmodule Controller do
  @moduledoc false

  alias Core.ApplicationLayer.SendMailservice

  alias Core.DomainLayer.UseCases.SendMailUseCase

  alias MailerAdapters

  @spec send_mail(binary(), binary(), binary(), binary()) ::
          SendMailUseCase.ok() | SendMailUseCase.error()
  def send_mail(from, to, subject, message) do
    SendMailservice.send(from, to, subject, message, MailerAdapters)
  end
end
