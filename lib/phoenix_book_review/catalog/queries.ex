defmodule PhoenixBookReview.Catalog.Queries do
  alias PhoenixBookReview.Catalog.{AuthorQueries, BookQueries}

  def list_authors_with_stats(sort_by \\ :name, order \\ :asc) do
    AuthorQueries.list_authors_with_stats(sort_by, order)
  end

  def top_rated_books(limit \\ 10) do
    BookQueries.top_rated_books(limit)
  end

  def top_selling_books(limit \\ 50) do
    BookQueries.top_selling_books(limit)
  end

  def search_books(search_term, page \\ 1, per_page \\ 20) do
    BookQueries.search_books(search_term, page, per_page)
  end
end