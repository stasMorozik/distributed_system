defmodule Core.DomainLayer.Ports.CreatingProductPort do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.ProductAggregate

  @type t :: Module

  @type ok :: {:ok, true}

  @type error :: {:error, ImpossibleCreateError.t()}

  @callback create(ProductAggregate.t()) :: ok() | error()
end
# INSERT INTO _  (email, password, id, created) VALUES (
#   'buyer@gmail.com',
#   '$2b$12$4mTHz/ZAPBfv3rX3mVLwq.GLCkiDaTjaMldj1y7g.PcB35oqP9yRW',
#   '515e85c8-b010-4f5b-8d7a-935772686420',
#   '2022-07-07 11:59:48'
# ) ON CONFLICT (email) DO NOTHING;
