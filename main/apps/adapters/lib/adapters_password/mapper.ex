defmodule Adapters.AdaptersPassword.Mapper do
  alias Core.CoreDomains.Domains.Password
  alias Core.CoreDomains.Domains.Password.ValueObjects.Email
  alias Core.CoreDomains.Domains.Password.ValueObjects.ConfirmingCode
  alias Core.CoreDomains.Domains.Password.ValueObjects.Confirmed
  alias Core.CoreDomains.Domains.Password.ValueObjects.Password, as: ValuePassword
  alias Core.CoreDomains.Common.ValueObjects.Id
  alias Core.CoreDomains.Common.ValueObjects.Created

  alias Core.CoreDomains.Domains.Password.Dtos.MapToDomainError

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
    {:error, MapToDomainError.new()}
  end

  def map_to_domain_with_code(%{
    confirmed: confirmed,
    created: created,
    email: email,
    id: id,
    password: password
  }, %{code: code}) do
    {
      :ok,
      %Password{
        confirmed: %Confirmed{value: confirmed},
        confirmed_code: %ConfirmingCode{value: code},
        email: %Email{value: email},
        id: %Id{value: id},
        password: %ValuePassword{value: password},
        created: %Created{value: created}
      }
    }
  end

  def map_to_domain_with_code(_,_) do
    {:error, MapToDomainError.new()}
  end
end
