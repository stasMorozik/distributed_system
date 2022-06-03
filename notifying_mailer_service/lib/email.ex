defmodule NotifyingMailerService.Email do
  import Bamboo.Email

  def create_email(to, subject, message) when
    is_binary(to) and
    is_binary(subject) and
    is_binary(message) do

    new_email(
      to: to,
      from: "support@myapp.com",
      subject: subject,
      html_body: "<strong>#{message}</strong>",
      text_body: message
    )
  end

  def create_email(_, _, _) do

  end
end
