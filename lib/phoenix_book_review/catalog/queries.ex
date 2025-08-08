defmodule PhoenixBookReview.Catalog.Queries do
  import Ecto.Query, warn: false
  alias PhoenixBookReview.Repo
  alias PhoenixBookReview.Catalog.{Author, Book, Review, Sales}

  def list_authors_with_stats(sort_by \\ :name, order \\ :asc) do
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

  def top_rated_books(limit \\ 10) do
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

  def top_selling_books(limit \\ 50) do
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

  def search_books(search_term, page \\ 1, per_page \\ 20) do
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