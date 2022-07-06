defmodule Core.DomainLayer.Dtos.NotFoundError do
  @moduledoc false
  alias Core.DomainLayer.Dtos.NotFoundError

  defstruct message: nil
end

defmodule Core.DomainLayer.Dtos.PasswordIsNotTrueError do
  @moduledoc false
  alias Core.DomainLayer.Dtos.PasswordIsNotTrueError

  defstruct message: nil
end

defmodule Core.ApplicationLayer.ConfirmingUserEmailService do
  @moduledoc false

  alias Core.DomainLayer.UseCases.ConfirmingUserEmailUseCase

  alias Core.DomainLayer.Ports.GettingUserByEmailPort
  alias Core.DomainLayer.Ports.CreatingConfirmingCodePort
  alias Core.DomainLayer.Ports.NotifyingMailPort

  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.Dtos.PasswordIsNotTrueError

  @behaviour ConfirmingUserEmailUseCase

  defmodule Core.DomainLayer.Dtos.AlreadyExistsError do
    @moduledoc false
    alias Core.DomainLayer.Dtos.AlreadyExistsError

    defstruct message: nil
  end

  alias Core.DomainLayer.Dtos.AlreadyExistsError

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
    with {:error, %NotFoundError{message: _}} <- getting_user_by_email_port.get(email, " "),
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
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
