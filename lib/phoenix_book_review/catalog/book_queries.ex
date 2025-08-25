defmodule PhoenixBookReview.Catalog.BookQueries do
  import Ecto.Query, warn: false
  alias PhoenixBookReview.Repo
  alias PhoenixBookReview.Catalog.{Author, Book}
  alias PhoenixBookReview.Services.CacheService

  def top_rated_books(limit \\ 10) do
    cache_key = "top_rated_books_#{limit}"
    
    case CacheService.get(cache_key) do
      nil ->
        result = fetch_top_rated_books(limit)
        CacheService.set(cache_key, result, 1800)
        result
      cached_result ->
        cached_result
    end
  end

  def top_selling_books(limit \\ 50) do
    cache_key = "top_selling_books_#{limit}"
    
    case CacheService.get(cache_key) do
      nil ->
        result = fetch_top_selling_books(limit)
        CacheService.set(cache_key, result, 1800)
        result
      cached_result ->
        cached_result
    end
  end

  def search_books(search_term, page \\ 1, per_page \\ 20) do
    cache_key = "search_books_#{:crypto.hash(:md5, search_term) |> Base.encode16()}_#{page}_#{per_page}"
    
    case CacheService.get(cache_key) do
      nil ->
        result = fetch_search_results(search_term, page, per_page)
        CacheService.set(cache_key, result, 600)
        result
      cached_result ->
        cached_result
    end
  end

  defp fetch_top_rated_books(limit) do
    from(b in Book,
      join: r in assoc(b, :reviews),
      join: a in assoc(b, :author),
      group_by: [b.id, a.name],
      select: %{
        book: b,
        author_name: a.name,
        avg_score: avg(r.score),
        review_count: count(r.id)
      },
      order_by: [desc: avg(r.score)],
      limit: ^limit
    )
    |> Repo.all()
  end

  defp fetch_top_selling_books(limit) do
    from(b in Book,
      join: s in assoc(b, :sales),
      join: a in assoc(b, :author),
      group_by: [b.id, a.name],
      select: %{
        book: b,
        author_name: a.name,
        total_sales: sum(s.sales_amount),
        author_total_sales: 0
      },
      order_by: [desc: sum(s.sales_amount)],
      limit: ^limit
    )
    |> Repo.all()
  end

  defp fetch_search_results(search_term, page, per_page) do
    offset = (page - 1) * per_page
    
    query = from(b in Book,
      join: a in assoc(b, :author),
      where: ilike(b.summary, ^"%#{search_term}%") or 
             ilike(b.name, ^"%#{search_term}%"),
      select: %{book: b, author_name: a.name},
      order_by: b.name,
      limit: ^per_page,
      offset: ^offset
    )
    
    books = Repo.all(query)
    
    total_query = from(b in Book,
      where: ilike(b.summary, ^"%#{search_term}%") or 
             ilike(b.name, ^"%#{search_term}%"),
      select: count()
    )
    
    total = Repo.one(total_query)
    
    %{
      books: books,
      page: page,
      per_page: per_page,
      total: total,
      total_pages: div(total + per_page - 1, per_page)
    }
  end
end