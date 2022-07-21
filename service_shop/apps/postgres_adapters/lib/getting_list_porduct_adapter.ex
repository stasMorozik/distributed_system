defmodule GettingListProductAdapter do
  @moduledoc false

  import Ecto.Query
  alias Shop.Repo

  alias Shop.ProductSchema

  alias Shop.OwnerProductSchema

  alias Shop.OwnerSchema

  alias Shop.LikeSchema

  alias Shop.DislikeSchema

  alias Core.DomainLayer.Ports.GettingListProductPort

  alias Core.DomainLayer.Dtos.ImpossibleGetError

  alias Core.DomainLayer.ValueObjects.Pagination

  alias Core.DomainLayer.ValueObjects.FiltrationProducts

  alias Core.DomainLayer.ValueObjects.SortingProducts

  alias Core.DomainLayer.ValueObjects.SplitingProducts

  alias Utils.ProductToDomain

  alias Core.DomainLayer.ValueObjects.Name
  alias Core.DomainLayer.ValueObjects.Email
  alias Core.DomainLayer.ValueObjects.Sorting
  alias Core.DomainLayer.ValueObjects.Splitting

  @behaviour GettingListProductPort

  @spec get(
          Pagination.t(),
          FiltrationProducts.t() | nil,
          SortingProducts.t() | nil,
          SplitingProducts.t() | nil
        ) :: GettingListProductPort.ok() | GettingListProductPort.error()
  def get(
        %Pagination{} = pagination,
        maybe_filtration,
        maybe_sorting,
        maybe_spliting
      ) do
    query =
      from(
        product in ProductSchema,
        as: :product,
        limit: ^pagination.limit,
        offset: ^pagination.offset,
        left_join: logo in assoc(product, :logo),
        join: owner in OwnerProductSchema,
        on: owner.product_id == product.id,
        join: true_owner in OwnerSchema,
        as: :true_owner,
        on: owner.owner_id == true_owner.id,
        left_join: like in LikeSchema,
        on: like.product_id == product.id,
        left_join: true_like in OwnerSchema,
        as: :true_like,
        on: like.owner_id == true_like.id,
        left_join: dislike in DislikeSchema,
        on: dislike.product_id == product.id,
        left_join: true_dislike in OwnerSchema,
        as: :true_dislike,
        on: dislike.owner_id == true_dislike.id,
        preload: [
          logo: logo,
          owner: true_owner,
          likes: true_like,
          dislikes: true_dislike
        ],
        group_by: [true_dislike.id, true_like.id, true_owner.id, logo.id, product.id]
      )

    case maybe_spliting != nil do
      true ->
        with {:ok, query} <- define_splitting(query, maybe_spliting) do
          list_product = Repo.all(query)

          {
            :ok,
            ProductToDomain.from_list_splitting(list_product)
          }
        else
          {:error, error_dto} -> {:error, error_dto}
        end

      false ->
        with {:ok, query} <- define_filtration(query, maybe_filtration),
             {:ok, query} <- define_sorting(query, maybe_sorting),
             query = define_select(query) do
          list_product = Repo.all(query)

          {
            :ok,
            ProductToDomain.from_list(list_product)
          }
        else
          {:error, error_dto} -> {:error, error_dto}
        end
    end
  end

  def get(_, _, _, _) do
    {:error, ImpossibleGetError.new()}
  end

  defp define_select(query) do
    query
    |> select(
      [product: product, true_like: true_like, true_dislike: true_dislike],
      {
        product,
        %{count: fragment("count(?) as like_count", true_like)},
        %{count: fragment("count(?) as dislike_count", true_dislike)}
      }
    )
  end

  defp define_filtration(query, %FiltrationProducts{
         provider: nil,
         name: %Name{value: name}
       }) do
    {
      :ok,
      query |> where([product: product], like(product.name, ^name))
    }
  end

  defp define_filtration(query, %FiltrationProducts{
         provider: %Email{value: provider},
         name: nil
       }) do
    {
      :ok,
      query |> where([true_owner: true_owner], true_owner.email == ^provider)
    }
  end

  defp define_filtration(query, %FiltrationProducts{
         provider: %Email{value: provider},
         name: %Name{value: name}
       }) do
    {
      :ok,
      query
      |> where([product: product], like(product.name, ^name))
      |> where([true_owner: true_owner], true_owner.email == ^provider)
    }
  end

  defp define_filtration(query, nil) do
    {:ok, query}
  end

  defp define_filtration(_, _) do
    {:error, ImpossibleGetError.new()}
  end

  defp define_sorting(query, %Sorting{
         type: :asc,
         value: :likes
       }) do
    {
      :ok,
      query |> order_by(fragment("like_count ASC"))
    }
  end

  defp define_sorting(query, %Sorting{
         type: :desc,
         value: :likes
       }) do
    {
      :ok,
      query |> order_by(fragment("like_count DESC"))
    }
  end

  defp define_sorting(query, %Sorting{
         type: :asc,
         value: :created
       }) do
    {
      :ok,
      query |> order_by([product: product], asc: :created)
    }
  end

  defp define_sorting(query, %Sorting{
         type: :desc,
         value: :created
       }) do
    {
      :ok,
      query |> order_by([product: product], desc: :created)
    }
  end

  defp define_sorting(query, %Sorting{
         type: :asc,
         value: :price
       }) do
    {
      :ok,
      query |> order_by([product: product], asc: :price)
    }
  end

  defp define_sorting(query, %Sorting{
         type: :desc,
         value: :price
       }) do
    {
      :ok,
      query |> order_by([product: product], desc: :price)
    }
  end

  defp define_sorting(query, nil) do
    {:ok, query}
  end

  defp define_sorting(_, _) do
    {:error, ImpossibleGetError.new()}
  end

  defp define_splitting(query, %Splitting{
         value: :provider,
         sort: :price
       }) do
    {
      :ok,
      query
      |> select(
        [
          product: product,
          true_like: true_like,
          true_dislike: true_dislike,
          true_owner: true_owner
        ],
        {
          product,
          %{count: fragment("count(?) as like_count", true_like)},
          %{count: fragment("count(?) as dislike_count", true_dislike)},
          %{
            row_number:
              row_number()
              |> over(partition_by: true_owner.email, order_by: product.price)
          }
        }
      )
    }
  end

  defp define_splitting(query, %Splitting{
         value: :price,
         sort: :likes
       }) do
    {
      :ok,
      query
      |> select(
        [product: product, true_like: true_like, true_dislike: true_dislike],
        {
          product,
          %{count: fragment("count(?) as like_count", true_like)},
          %{count: fragment("count(?) as dislike_count", true_dislike)},
          %{
            row_number:
              row_number()
              |> over(partition_by: product.price, order_by: fragment("count(?) ASC", true_like))
          }
        }
      )
    }
  end

  defp define_splitting(query, %Splitting{
         value: :amount,
         sort: :price
       }) do
    {
      :ok,
      query
      |> select(
        [product: product, true_like: true_like, true_dislike: true_dislike],
        {
          product,
          %{count: fragment("count(?) as like_count", true_like)},
          %{count: fragment("count(?) as dislike_count", true_dislike)},
          %{
            row_number:
              row_number()
              |> over(partition_by: product.amount, order_by: product.price)
          }
        }
      )
    }
  end

  defp define_splitting(query, nil) do
    {
      :ok,
      query
    }
  end

  defp define_splitting(_, _) do
    {:error, ImpossibleGetError.new()}
  end
end
