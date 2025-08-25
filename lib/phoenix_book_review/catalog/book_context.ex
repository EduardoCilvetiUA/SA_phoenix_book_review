defmodule PhoenixBookReview.Catalog.BookContext do
  import Ecto.Query, warn: false
  alias PhoenixBookReview.Repo
  alias PhoenixBookReview.Catalog.{Book, Review, Sales}
  alias PhoenixBookReview.Services.CacheInvalidation

  def list_books do
    Repo.all(Book) |> Repo.preload(:author)
  end

  def get_book!(id), do: Repo.get!(Book, id) |> Repo.preload(:author)

  def create_book(attrs) do
    result = %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()

    case result do
      {:ok, _book} -> CacheInvalidation.invalidate_book_caches()
      _ -> :ok
    end

    result
  end

  def update_book(%Book{} = book, attrs) do
    result = book
    |> Book.changeset(attrs)
    |> Repo.update()

    case result do
      {:ok, _book} -> CacheInvalidation.invalidate_book_caches()
      _ -> :ok
    end

    result
  end

  def delete_book(%Book{} = book) do
    result = Repo.transaction(fn ->
      delete_book_cascade(book)
    end)

    case result do
      {:ok, _} -> CacheInvalidation.invalidate_all_caches()
      _ -> :ok
    end

    result
  end

  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  defp delete_book_cascade(%Book{} = book) do
    from(r in Review, where: r.book_id == ^book.id) |> Repo.delete_all()
    from(s in Sales, where: s.book_id == ^book.id) |> Repo.delete_all()
    Repo.delete!(book)
  end
end