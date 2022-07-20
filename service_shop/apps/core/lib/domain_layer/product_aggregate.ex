defmodule Core.DomainLayer.ProductAggregate do
  @moduledoc false

  alias Core.DomainLayer.Dtos.ImpossibleCreateError
  alias Core.DomainLayer.Dtos.ImpossibleUpdateError
  alias Core.DomainLayer.Dtos.NotFoundError
  alias Core.DomainLayer.Dtos.ImpossibleDeleteError
  alias Core.DomainLayer.Dtos.ListImageIsTooLongError
  alias Core.DomainLayer.Dtos.AlreadyExistsError

  alias Core.DomainLayer.ValueObjects.Id
  alias Core.DomainLayer.ValueObjects.Created
  alias Core.DomainLayer.ValueObjects.Name
  alias Core.DomainLayer.ValueObjects.Amount
  alias Core.DomainLayer.ValueObjects.Description
  alias Core.DomainLayer.ValueObjects.Price

  alias Core.DomainLayer.ImageEntity
  alias Core.DomainLayer.OwnerEntity

  alias Core.DomainLayer.ProductAggregate

  defstruct id: nil,
            name: nil,
            created: nil,
            amount: nil,
            ordered: nil,
            description: nil,
            price: nil,
            logo: nil,
            images: [],
            likes: [],
            dislikes: [],
            like_count: nil,
            dislike_count: nil,
            owner: nil

  @type t :: %ProductAggregate{
          id: Id.t(),
          name: Name.t(),
          created: Created.t(),
          amount: Amount.t(),
          ordered: Amount.t(),
          description: Description.t(),
          price: Price.t(),
          logo: ImageEntity.t(),
          images: list(ImageEntity.t()),
          likes: list(OwnerEntity.t()),
          dislikes: list(OwnerEntity.t()),
          like_count: Amount.t(),
          dislike_count: Amount.t(),
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
          | {:error, ImpossibleUpdateError.t()}

  @type error_voiting ::
          {:error, ImpossibleUpdateError.t()}
          | {:error, AlreadyExistsError.t()}

  @type voiting_dto :: %{
          id: binary(),
          email: binary()
        }

  @type error_deleting_image ::
          {:error, NotFoundError.t()}
          | {:error, ImpossibleDeleteError.t()}

  @type error_adding_image ::
          {:error, ImpossibleUpdateError.t()}
          | {:error, ListImageIsTooLongError.t()}

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

  @type updating_dto :: %{
          name: binary()        | nil,
          amount: integer()     | nil,
          description: binary() | nil,
          price: integer()      | nil,
          logo: binary()        | nil
        }

  @spec new(creating_dto()) :: ok() | error_creating()
  def new(%{} = dto) do
    with {:ok, value_name} <- Name.new(dto[:name]),
         {:ok, value_desc} <- Description.new(dto[:description]),
         {:ok, value_price} <- Price.new(dto[:price]),
         {:ok, value_amount} <- Amount.new(dto[:amount]),
         {:ok, value_ordered} <- Amount.new(0),
         {:ok, entity_logo} <- ImageEntity.new(dto[:logo]),
         {:ok, entity_owner} <- OwnerEntity.new(%{email: dto[:owner][:email], id: dto[:owner][:id]}),
         images <-
           Enum.map(dto[:images], fn image -> ImageEntity.new(image) end)
           |> Enum.filter(fn {result, _} -> result == :ok end)
           |> Enum.map(fn {_, entity_image} -> entity_image end)
           |> Enum.take(4) do
      {
        :ok,
        %ProductAggregate{
          id: Id.new(),
          created: Created.new(),
          name: value_name,
          amount: value_amount,
          ordered: value_ordered,
          description: value_desc,
          price: value_price,
          logo: entity_logo,
          owner: entity_owner,
          images: images,
          likes: [],
          dislikes: [],
          like_count: %Amount{value: 0},
          dislike_count: %Amount{value: 0},
        }
      }
    else
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def new(_) do
    {:error, ImpossibleCreateError.new()}
  end

  @spec update(ProductAggregate.t(), updating_dto()) :: ok() | error_updating()
  def update(%ProductAggregate{} = entity, %{} = dto)
      when is_map(dto) and is_struct(dto) == false and map_size(dto) > 0 do
    case is_empty(dto) do
      true ->
        {:error, ImpossibleUpdateError.new()}

      false ->
        update_name({:ok, entity}, dto)
        |> update_desc(dto)
        |> update_price(dto)
        |> update_amount(dto)
        |> update_ordered(dto)
        |> update_logo(dto)
    end
  end

  def update(_, _) do
    {:error, ImpossibleUpdateError.new()}
  end

  @spec delete_image(ProductAggregate.t(), Id.t()) :: ok() | error_deleting_image()
  def delete_image(%ProductAggregate{} = entity, %Id{} = id_image) when is_binary(id_image.value) do
    with true <- Enum.any?(entity.images, fn image -> image.id.value == id_image.value end),
         images = Enum.filter(entity.images, fn image -> image.id.value == id_image.value end) do
      {
        :ok,
        %ProductAggregate{entity | images: images}
      }
    else
      false -> {:error, NotFoundError.new("Image")}
    end
  end

  def delete_image(_, _) do
    {:error, ImpossibleDeleteError.new()}
  end

  @spec add_image(ProductAggregate.t(), list(ImageEntity.t())) :: ok() | error_adding_image()
  def add_image(%ProductAggregate{} = entity, list_image_entity) when is_list(list_image_entity) do
    with true <- length(entity.images) < 4,
         true <- length(entity.images) + length(list_image_entity) < 4 do
      {
        :ok,
        %ProductAggregate{entity | images: list_image_entity ++ entity.images}
      }
    else
      false -> {:error, ListImageIsTooLongError.new()}
      {:ok, error_dto} -> {:ok, error_dto}
    end
  end

  def add_image(_, _) do
    {:error, ImpossibleUpdateError.new()}
  end

  @spec like(ProductAggregate.t(), OwnerEntity.t()) :: ok() | error_voiting()
  def like(%ProductAggregate{} = entity, %OwnerEntity{} = owner_entity)
      when is_struct(owner_entity) and is_struct(entity) do
    with false <- Enum.any?(entity.likes, fn owner -> owner.id.value == owner_entity.id.value end) do
      {
        :ok,
        Map.update!(entity, :likes, fn likes -> [owner_entity | likes] end)
        |> Map.update!(
          :dislikes,
          fn dislikes ->
            Enum.filter(
              dislikes,
              fn dislike -> dislike.id.value != owner_entity.id.value end
            )
          end
        )
      }
    else
      true -> {:error, AlreadyExistsError.new("Like")}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def like(_, _) do
    {:error, ImpossibleUpdateError.new()}
  end

  @spec dislike(ProductAggregate.t(), OwnerEntity.t()) :: ok() | error_voiting()
  def dislike(%ProductAggregate{} = entity, %OwnerEntity{} = owner_entity)
      when is_struct(owner_entity) and is_struct(entity) do
    with false <- Enum.any?(entity.dislikes, fn owner -> owner.id.value == owner_entity.id.value end) do
      {
        :ok,
        Map.update!(entity, :dislikes, fn dislikes -> [owner_entity | dislikes] end)
        |> Map.update!(
          :likes,
          fn likes ->
            Enum.filter(
              likes,
              fn like -> like.id.value != owner_entity.id.value end
            )
          end
        )
      }
    else
      true -> {:error, AlreadyExistsError.new("Dislike")}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  def dislike(_, _) do
    {:error, ImpossibleUpdateError.new()}
  end

  defp update_name({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:name] != nil,
         {:ok, value_name} <- Name.new(dto[:name]) do
      {:ok, %ProductAggregate{maybe_entity | name: value_name}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_desc({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:description] != nil,
         {:ok, value_desc} <- Description.new(dto[:description]) do
      {:ok, %ProductAggregate{maybe_entity | description: value_desc}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_price({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:price] != nil,
         {:ok, value_price} <- Price.new(dto[:price]) do
      {:ok, %ProductAggregate{maybe_entity | price: value_price}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_amount({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:amount] != nil,
         {:ok, value_amount} <- Amount.new(dto[:amount]) do
      {:ok, %ProductAggregate{maybe_entity | amount: value_amount}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_ordered({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:ordered] != nil,
         {:ok, value_amount} <- Amount.new(dto[:ordered]) do
      {:ok, %ProductAggregate{maybe_entity | ordered: value_amount}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp update_logo({result, maybe_entity}, %{} = dto) do
    with true <- result == :ok,
         true <- dto[:logo] != nil,
         {:ok, image_entity} <- ImageEntity.update(maybe_entity.logo, dto[:logo]) do
      {:ok, %ProductAggregate{maybe_entity | logo: image_entity}}
    else
      false -> {result, maybe_entity}
      {:error, error_dto} -> {:error, error_dto}
    end
  end

  defp is_empty(%{} = dto) do
    cond do
      Map.has_key?(dto, :name) == true -> false
      Map.has_key?(dto, :amount) == true -> false
      Map.has_key?(dto, :description) == true -> false
      Map.has_key?(dto, :price) == true -> false
      Map.has_key?(dto, :ordered) == true -> false
      true -> true
    end
  end
end
