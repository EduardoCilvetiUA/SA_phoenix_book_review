defmodule PhoenixBookReview.Catalog.AuthorContext do
  import Ecto.Query, warn: false
  alias PhoenixBookReview.Repo
  alias PhoenixBookReview.Catalog.{Author, Book, Review, Sales}
  alias PhoenixBookReview.Services.CacheInvalidation

  def list_authors do
    Repo.all(Author)
  end

  def get_author!(id), do: Repo.get!(Author, id)

  def create_author(attrs) do
    result = %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()

    case result do
      {:ok, _author} -> CacheInvalidation.invalidate_author_caches()
      _ -> :ok
    end

    result
  end

  def update_author(%Author{} = author, attrs) do
    result = author
    |> Author.changeset(attrs)
    |> Repo.update()

    case result do
      {:ok, _author} -> CacheInvalidation.invalidate_author_caches()
      _ -> :ok
    end

    result
  end

  def delete_author(%Author{} = author) do
    result = Repo.transaction(fn ->
      books = from(b in Book, where: b.author_id == ^author.id) |> Repo.all()
      
      for book <- books do
        delete_book_cascade(book)
      end
      
      Repo.delete!(author)
    end)

    case result do
      {:ok, _} -> CacheInvalidation.invalidate_all_caches()
      _ -> :ok
    end

    result
  end

  def change_author(%Author{} = author, attrs \\ %{}) do
    Author.changeset(author, attrs)
  end

  defp delete_book_cascade(%Book{} = book) do
    from(r in Review, where: r.book_id == ^book.id) |> Repo.delete_all()
    from(s in Sales, where: s.book_id == ^book.id) |> Repo.delete_all()
    Repo.delete!(book)
  end
end