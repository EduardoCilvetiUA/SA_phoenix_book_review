defmodule PhoenixBookReview.Catalog.ReviewContext do
  alias PhoenixBookReview.Repo
  alias PhoenixBookReview.Catalog.Review
  alias PhoenixBookReview.Services.{CacheInvalidation, SearchService}

  def list_reviews do
    Repo.all(Review) |> Repo.preload(:book)
  end

  def get_review!(id), do: Repo.get!(Review, id) |> Repo.preload(:book)

  def create_review(attrs) do
    result = %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()

    case result do
      {:ok, review} -> 
        CacheInvalidation.invalidate_review_caches()
        SearchService.index_review(review)
      _ -> :ok
    end

    result
  end

  def update_review(%Review{} = review, attrs) do
    result = review
    |> Review.changeset(attrs)
    |> Repo.update()

    case result do
      {:ok, updated_review} -> 
        CacheInvalidation.invalidate_review_caches()
        SearchService.index_review(updated_review)
      _ -> :ok
    end

    result
  end

  def delete_review(%Review{} = review) do
    result = Repo.delete(review)

    case result do
      {:ok, _} -> 
        CacheInvalidation.invalidate_review_caches()
        SearchService.delete_review(review.id)
      _ -> :ok
    end

    result
  end

  def change_review(%Review{} = review, attrs \\ %{}) do
    Review.changeset(review, attrs)
  end
end