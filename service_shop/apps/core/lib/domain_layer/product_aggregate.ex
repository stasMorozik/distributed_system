defmodule Core.DomainLayer.ProductAggregate do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.ImpossibleUpdateError

  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Name
  alias Core.DomainLayer.ValueObjects.Amount
  alias Core.DomainLayer.ValueObjects.Description
  alias Core.DomainLayer.ValueObjects.Price

  alias Core.DomainLayer.ImageEntity
  alias Core.DomainLayer.OwnerEntity

  @type t :: %ProductAggregate{
            id: Id.t(),
            name: Name.t(),
            created: Created.t(),
            amount: Amount.t(),
            description: Description.t(),
            price: Price.t(),
            logo: ImageEntity.t(),
            images: list(ImageEntity.t()),
            likes: list(OwnerEntity.t()),
            owner: OwnerEntity.t()
        }

  @type ok :: {:ok, ProductAggregate.t()}

  @type error_creating ::
          Name.error()
          | Amount.error()
          | Description.error()
          | Price.error()
          | ImageEntity.error_creating()
          | OwnerEntity.error_creating()
          | {:error, ImpossibleCreateError.t()}

  @type error_updating ::
          Name.error()
          | Amount.error()
          | Description.error()
          | Price.error()
          | ImageEntity.error_creating()
          | {:error, ImpossibleUpdateError.t()}

  @type error_voiting :: {:error, ImpossibleUpdateError.t()}


end
