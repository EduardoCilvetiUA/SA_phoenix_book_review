defmodule PhoenixBookReview.Catalog.ReviewContext do
  alias PhoenixBookReview.Repo
  alias PhoenixBookReview.Catalog.Review
  alias PhoenixBookReview.Services.CacheInvalidation

  def list_reviews do
    Repo.all(Review) |> Repo.preload(:book)
  end

  def get_review!(id), do: Repo.get!(Review, id) |> Repo.preload(:book)

  def create_review(attrs) do
    result = %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()

    case result do
      {:ok, _review} -> CacheInvalidation.invalidate_review_caches()
      _ -> :ok
    end

    result
  end

  def update_review(%Review{} = review, attrs) do
    result = review
    |> Review.changeset(attrs)
    |> Repo.update()

    case result do
      {:ok, _review} -> CacheInvalidation.invalidate_review_caches()
      _ -> :ok
    end

    result
  end

  def delete_review(%Review{} = review) do
    result = Repo.delete(review)

    case result do
      {:ok, _review} -> CacheInvalidation.invalidate_review_caches()
      _ -> :ok
    end

    result
  end

  def change_review(%Review{} = review, attrs \\ %{}) do
    Review.changeset(review, attrs)
  end
end