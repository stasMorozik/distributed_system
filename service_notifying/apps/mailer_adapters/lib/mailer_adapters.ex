defmodule MailerAdapters do
  @moduledoc false

  alias MailerAdapters.Email, as: NewEamil
  alias MailerAdapters.Mailer
  alias Core.DomainLayer.ValueObjects.Subject

  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Message
  alias Core.DomainLayer.ValueObjects.Subject

  alias Core.DomainLayer.Ports.SendMailPort

  alias Core.DomainLayer.NotificationEntity

  alias Core.DomainLayer.Dtos.ImpossibleSendError

  @behaviour SendMailPort

  @spec send(NotificationEntity.t()) :: SendMailPort.ok() | SendMailPort.error()
  def send(%NotificationEntity{
    from: %Email{value: from},
    to: %Email{value: to},
    created: %Created{value: created},
    message: %Message{value: message},
    subject: %Subject{value: subject}
  }) do
    is_date_time = fn
      %DateTime{} = _ -> true
      _ -> false
    end

    with true <- is_binary(from),
         true <- is_binary(to),
         true <- is_binary(message),
         true <- is_binary(subject),
         true <- is_struct(created),
         true <- is_date_time.(created) do
      NewEamil.create_email(from, to, subject, "#{DateTime.to_string(created)} #{message}") |> Mailer.deliver_now!()
      {:ok, true}
    else
      false -> {:error, ImpossibleSendError.new()}
    end
  end

  def send(_) do
    {:error, ImpossibleSendError.new()}
  end
end
