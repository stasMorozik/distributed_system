defmodule MailerAdapters.Email do
  import Bamboo.Email

  def create_email(from, to, subject, message) do
    new_email(
      to: to,
      from: from,
      subject: subject,
      html_body: "<strong>#{message}</strong>",
      text_body: message
    )
  end
end
