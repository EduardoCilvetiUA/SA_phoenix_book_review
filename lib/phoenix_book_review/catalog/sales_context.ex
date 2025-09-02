defmodule PhoenixBookReview.Catalog.SalesContext do
  alias PhoenixBookReview.Repo
  alias PhoenixBookReview.Catalog.Sales
  alias PhoenixBookReview.Services.CacheInvalidation

  def list_sales do
    Repo.all(Sales) |> Repo.preload(:book)
  end

  def get_sales!(id), do: Repo.get!(Sales, id) |> Repo.preload(:book)

  def create_sales(attrs) do
    result = %Sales{}
    |> Sales.changeset(attrs)
    |> Repo.insert()

    case result do
      {:ok, _sales} -> CacheInvalidation.invalidate_sales_caches()
      _ -> :ok
    end

    result
  end

  def update_sales(%Sales{} = sales, attrs) do
    result = sales
    |> Sales.changeset(attrs)
    |> Repo.update()

    case result do
      {:ok, _sales} -> CacheInvalidation.invalidate_sales_caches()
      _ -> :ok
    end

    result
  end

  def delete_sales(%Sales{} = sales) do
    result = Repo.delete(sales)

    case result do
      {:ok, _sales} -> CacheInvalidation.invalidate_sales_caches()
      _ -> :ok
    end

    result
  end

  def change_sales(%Sales{} = sales, attrs \\ %{}) do
    Sales.changeset(sales, attrs)
  end
end