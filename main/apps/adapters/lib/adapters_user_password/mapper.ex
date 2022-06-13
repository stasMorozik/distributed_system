defmodule Adapters.AdaptersUserPassword.Mapper do
  alias Core.CoreDomains.Domains.Password
  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode
  alias Core.CoreDomains.Domains.Password.ValueObjects.Confirmed
  alias Core.CoreDomains.Domains.Password.ValueObjects.Password, as: ValuePassword
  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.ValueObjects.Created

  alias Core.CoreDomains.Common.Dtos.MapToDomainError

  def map_to_domain(%{
    confirmed: confirmed,
    created: created,
    email: email,
    id: id,
    password: password
  }) do
    {
      :ok,
      %Password{
        confirmed: %Confirmed{value: confirmed},
        email: %Email{value: email},
        id: %Id{value: id},
        password: %ValuePassword{value: password},
        created: %Created{value: created}
      }
    }
  end

  def map_to_domain(_) do
    {:error, MapToDomainError.new("Error mapping password to domain")}
  end

  def map_to_domain_confirming_code(%{code: code, email: email}) do
    {:ok, %ConfirmingCode{code: code, email: email}}
  end

  def map_to_domain_confirming_code(_) do
    {:error, MapToDomainError.new("Error mapping confirming code to domain")}
  end

end
