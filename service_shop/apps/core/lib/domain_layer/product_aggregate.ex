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

  alias Core.DomainLayer.ProductAggregate

  alias Core.DomainLayer.ImageEntity
  alias Core.DomainLayer.OwnerEntity

  defstruct id: nil,
            name: nil,
            created: nil,
            amount: nil,
            description: nil,
            price: nil,
            logo: nil,
            images: [],
            likes: [],
            owner: nil

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

  @type creating_dto :: %{
          name: binary(),
          amount: integer(),
          description: binary(),
          price: integer(),
          logo: binary(),
          images: list(binary()),
          owner: %{
            id: binary(),
            email: binary()
          }
        }

  @spec new(creating_dto()) :: ok() | error_creating()
  def new(%{} = dto) do
    with {:ok, value_name} <- Name.new(dto[:name]),
         {:ok, value_desc} <- Description.new(dto[:description]),
         {:ok, value_price} <- Price.new(dto[:price]),
         {:ok, value_amount} <- Amount.new(dto[:price]),
         {:ok, entity_logo} <- ImageEntity.new(dto[:logo]),
         {:ok, entity_owner} <- OwnerEntity.new(dto[:owner][:email], dto[:owner][:id]),
         images <- Enum.map(dto[:images], fn image -> ImageEntity.new(image) end)
          |> Enum.filter(fn {result, _} -> result == :ok end)
          |> Enum.map(fn {_, entity_image} -> entity_image end)
          |> Enum.take(4) do
      {
        :ok,
        %ProductAggregate{
          name: value_name,
          amount: value_amount,
          description: value_desc,
          price: value_price,
          logo: entity_logo,
          owner: entity_owner,
          images: images,
          likes: []
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end
end
