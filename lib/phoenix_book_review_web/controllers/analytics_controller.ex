defmodule PhoenixBookReviewWeb.AnalyticsController do
  use PhoenixBookReviewWeb, :controller

  alias PhoenixBookReview.Catalog

  def index(conn, _params) do
    render(conn, :index)
  end

  def authors_stats(conn, params) do
    sort_by = String.to_existing_atom(params["sort_by"] || "name")
    order = String.to_existing_atom(params["order"] || "asc")
    
    authors_stats = Catalog.list_authors_with_stats(sort_by, order)
    render(conn, :authors_stats, authors_stats: authors_stats)
  end

  def top_rated_books(conn, _params) do
    top_books = Catalog.top_rated_books(10)
    render(conn, :top_rated_books, top_books: top_books)
  end

  def top_selling_books(conn, _params) do
    top_books = Catalog.top_selling_books(50)
    render(conn, :top_selling_books, top_books: top_books)
  end

  def search_books(conn, params) do
    search_term = params["q"] || ""
    page = String.to_integer(params["page"] || "1")
    
    if search_term != "" do
      results = Catalog.search_books(search_term, page)
      render(conn, :search_results, results: results, search_term: search_term)
    else
      render(conn, :search_form, search_term: search_term)
    end
  end
end