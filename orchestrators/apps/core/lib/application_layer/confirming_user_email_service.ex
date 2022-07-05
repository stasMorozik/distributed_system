defmodule Core.ApplicationLayer.ConfirmingUserEmailService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.ConfirmingUserEmailUseCase

  alias Core.DomainLayer.Ports.GettingUserByEmailPort
  alias Core.DomainLayer.Ports.CreatingConfirmingCodePort
  alias Core.DomainLayer.Ports.NotifyingMailPort

  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.Dtos.AlreadyExistsError
  alias Core.DomainLayer.Dtos.PasswordIsNotTrueError
  alias Core.DomainLayer.Dtos.PasswordIsInvalidError
  alias Core.DomainLayer.Dtos.ImpossibleValidatePasswordError

  @behaviour ConfirmingUserEmailUseCase

  @spec send_to_email_code(
          binary(),
          GettingUserByEmailPort.t(),
          CreatingConfirmingCodePort.t(),
          NotifyingMailPort.t()
        ) :: ConfirmingUserEmailUseCase.ok() | ConfirmingUserEmailUseCase.error()
  def send_to_email_code(
        email,
        getting_user_by_email_port,
        creating_confirming_code_port,
        notifying_mail_port
      ) do
    with {:error, %NotFoundError{message: _}} <- getting_user_by_email_port.get(email, "0"),
         {:ok, confirming_code} <- creating_confirming_code_port.create(email),
         code <- confirming_code.code.value,
         {:ok, true} <-
           notifying_mail_port.send_mail(
             "support@gmail.com",
             email,
             "Confirming code",
             "Your code is #{code}"
           ) do
      {:ok, true}
    else
      {:error, %PasswordIsNotTrueError{message: _}} -> {:error, %AlreadyExistsError{message: "User with this email already exists"}}
      {:error, %PasswordIsInvalidError{message: _}} -> {:error, %AlreadyExistsError{message: "User with this email already exists"}}
      {:error, %ImpossibleValidatePasswordError{message: _}} -> {:error, %AlreadyExistsError{message: "User with this email already exists"}}
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
