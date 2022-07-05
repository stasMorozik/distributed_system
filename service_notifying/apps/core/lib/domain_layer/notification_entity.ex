defmodule Core.DomainLayer.NotificationEntity do
  @moduledoc false

  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.ChatName
  alias Core.DomainLayer.ValueObjects.Message
  alias Core.DomainLayer.ValueObjects.Subject

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.MessageIsTooLongError
  alias Core.DomainLayer.Dtos.EmailIsInvalidError
  alias Core.DomainLayer.Dtos.NameIsInvalidError
  alias Core.DomainLayer.Dtos.MessageIsInvalidError
  alias Core.DomainLayer.Dtos.SubjectIsTooLongError
  alias Core.DomainLayer.Dtos.SubjectIsInvalidError

  alias Core.DomainLayer.NotificationEntity

  defstruct from: nil, to: nil, created: nil, subject: nil, message: nil

  @type t :: %NotificationEntity{
          from: Email.t() | ChatName.t(),
          to: Email.t() | ChatName.t(),
          created: Created.t(),
          subject: Subject.t(),
          message: Message.t()
        }

  @type ok :: {:ok, NotificationEntity.t()}

  @type error_creating ::
          {
            :error,
            ImpossibleCreateError.t()
            | MessageIsTooLongError.t()
            | EmailIsInvalidError.t()
            | NameIsInvalidError.t()
            | MessageIsInvalidError.t()
            | SubjectIsTooLongError.t()
            | SubjectIsInvalidError.t()
          }

  @spec new_for_email(binary(), binary(), binary(), binary()) :: ok() | error_creating()
  def new_for_email(from, to, subject, mess)
      when is_binary(from) and is_binary(to) and is_binary(subject) and is_binary(mess) do
    with {:ok, value_email_from} <- Email.new(from),
         {:ok, value_email_to} <- Email.new(to),
         {:ok, value_email_mess} <- Message.new(mess),
         {:ok, value_email_sub} <- Subject.new(subject) do
      {
        :ok,
        %NotificationEntity{
          from: value_email_from,
          to: value_email_to,
          message: value_email_mess,
          subject: value_email_sub,
          created: Created.new()
        }
      }
    end
  end

  def new_for_email(_, _, _, _) do
    {:error, ImpossibleCreateError.new()}
  end
end
