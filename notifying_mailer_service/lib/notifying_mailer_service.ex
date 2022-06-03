defmodule NotifyingMailerService do
  alias NotifyingMailerService.Email
  alias NotifyingMailerService.Mailer

  def notify(to, subject, message) when
    is_binary(to) and
    is_binary(subject) and
    is_binary(message) do

    Email.create_email(to, subject, message) |> Mailer.deliver_now!()
  end

  def notify(_, _, _) do

  end

end
