defmodule Core.DomainLayer.Domains.User.Dtos.CreatingData do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.Dtos.CreatingData

  defstruct name: nil,
            surname: nil,
            email: nil,
            phone: nil,
            password: nil,
            confirming_code: nil

  @type t :: %CreatingData{
          name: binary(),
          surname: binary(),
          email: binary(),
          phone: binary(),
          password: binary(),
          confirming_code: integer()
        }

  @spec new(binary(), binary(), binary(), binary(), binary(), integer()) :: CreatingData.t()
  def new(name, surname, email, phone, password, confirming_code) do
    %CreatingData{
      name: name,
      surname: surname,
      email: email,
      phone: phone,
      password: password,
      confirming_code: confirming_code
    }
  end
end
