defmodule PhoenixBookReview.Catalog do
  @moduledoc """
  The Catalog context.
  """

  alias PhoenixBookReview.Catalog.{AuthorContext, BookContext, ReviewContext, SalesContext, Queries}

  defdelegate list_authors(), to: AuthorContext
  defdelegate get_author!(id), to: AuthorContext
  defdelegate create_author(attrs), to: AuthorContext
  defdelegate update_author(author, attrs), to: AuthorContext
  defdelegate delete_author(author), to: AuthorContext
  defdelegate change_author(author, attrs \\ %{}), to: AuthorContext

  defdelegate list_books(), to: BookContext
  defdelegate get_book!(id), to: BookContext
  defdelegate create_book(attrs), to: BookContext
  defdelegate update_book(book, attrs), to: BookContext
  defdelegate delete_book(book), to: BookContext
  defdelegate change_book(book, attrs \\ %{}), to: BookContext

  defdelegate list_reviews(), to: ReviewContext
  defdelegate get_review!(id), to: ReviewContext
  defdelegate create_review(attrs), to: ReviewContext
  defdelegate update_review(review, attrs), to: ReviewContext
  defdelegate delete_review(review), to: ReviewContext
  defdelegate change_review(review, attrs \\ %{}), to: ReviewContext

  defdelegate list_sales(), to: SalesContext
  defdelegate get_sales!(id), to: SalesContext
  defdelegate create_sales(attrs), to: SalesContext
  defdelegate update_sales(sales, attrs), to: SalesContext
  defdelegate delete_sales(sales), to: SalesContext
  defdelegate change_sales(sales, attrs \\ %{}), to: SalesContext

  defdelegate list_authors_with_stats(sort_by \\ :name, order \\ :asc), to: Queries
  defdelegate top_rated_books(limit \\ 10), to: Queries
  defdelegate top_selling_books(limit \\ 50), to: Queries
  defdelegate search_books(search_term, page \\ 1, per_page \\ 20), to: Queries
end