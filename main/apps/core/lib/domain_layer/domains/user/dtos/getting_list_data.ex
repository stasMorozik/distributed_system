defmodule Core.DomainLayer.Domains.User.Dtos.GettingListData do
  @moduledoc false

  alias Core.DomainLayer.Domains.User.Dtos.GettingListData

  defstruct sorting: nil, filtration: nil, pagination: nil

  @type param :: %{
    type: binary(),
    value: binary()
  }

  @type pagi :: %{
    take: integer(), from: integer(), to: integer()
  }

  @type t :: %GettingListData{
          sorting: nonempty_list(param()),
          filtration: nonempty_list(param()),
          pagination: pagi(),
        }
end
