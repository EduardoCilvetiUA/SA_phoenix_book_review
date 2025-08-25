defmodule PhoenixBookReview.Catalog.AuthorQueries do
  import Ecto.Query, warn: false
  alias PhoenixBookReview.Repo
  alias PhoenixBookReview.Catalog.Author
  alias PhoenixBookReview.Services.CacheService

  def list_authors_with_stats(sort_by \\ :name, order \\ :asc) do
    cache_key = "authors_stats_#{sort_by}_#{order}"
    
    case CacheService.get(cache_key) do
      nil ->
        result = fetch_authors_with_stats(sort_by, order)
        CacheService.set(cache_key, result, 1800)
        result
      cached_result ->
        cached_result
    end
  end

  defp fetch_authors_with_stats(sort_by, order) do
    from(a in Author,
      left_join: b in assoc(a, :books),
      left_join: r in assoc(b, :reviews),
      left_join: s in assoc(b, :sales),
      group_by: a.id,
      select: %{
        author: a,
        book_count: count(b.id, :distinct),
        avg_score: avg(r.score),
        total_sales: sum(s.sales_amount)
      },
      order_by: [{^order, field(a, ^sort_by)}]
    )
    |> Repo.all()
  end
end