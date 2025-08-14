defmodule PhoenixBookReview.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias PhoenixBookReview.Repo

  alias PhoenixBookReview.Catalog.{Author, Book, Review, Sales, Queries}

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Repo.all(Author)
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id), do: Repo.get!(Author, id)

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.transaction(fn ->
      books = from(b in Book, where: b.author_id == ^author.id) |> Repo.all()
      
      for book <- books do
        delete_book_cascade(book)
      end
      
      Repo.delete!(author)
    end)
  end

  defp delete_book_cascade(%Book{} = book) do
    from(r in Review, where: r.book_id == ^book.id) |> Repo.delete_all()
    from(s in Sales, where: s.book_id == ^book.id) |> Repo.delete_all()
    Repo.delete!(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{data: %Author{}}

  """
  def change_author(%Author{} = author, attrs \\ %{}) do
    Author.changeset(author, attrs)
  end

  def list_books do
    Repo.all(Book) |> Repo.preload(:author)
  end

  def get_book!(id), do: Repo.get!(Book, id) |> Repo.preload(:author)

  def create_book(attrs) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  def delete_book(%Book{} = book) do
    Repo.transaction(fn ->
      delete_book_cascade(book)
    end)
  end

  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  def list_reviews do
    Repo.all(Review) |> Repo.preload(:book)
  end

  def get_review!(id), do: Repo.get!(Review, id) |> Repo.preload(:book)

  def create_review(attrs) do
    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()
  end

  def update_review(%Review{} = review, attrs) do
    review
    |> Review.changeset(attrs)
    |> Repo.update()
  end

  def delete_review(%Review{} = review) do
    Repo.delete(review)
  end

  def change_review(%Review{} = review, attrs \\ %{}) do
    Review.changeset(review, attrs)
  end

  def list_sales do
    Repo.all(Sales) |> Repo.preload(:book)
  end

  def get_sales!(id), do: Repo.get!(Sales, id) |> Repo.preload(:book)

  def create_sales(attrs) do
    %Sales{}
    |> Sales.changeset(attrs)
    |> Repo.insert()
  end

  def update_sales(%Sales{} = sales, attrs) do
    sales
    |> Sales.changeset(attrs)
    |> Repo.update()
  end

  def delete_sales(%Sales{} = sales) do
    Repo.delete(sales)
  end

  def change_sales(%Sales{} = sales, attrs \\ %{}) do
    Sales.changeset(sales, attrs)
  end

  def list_authors_with_stats(sort_by \\ :name, order \\ :asc) do
    Queries.list_authors_with_stats(sort_by, order)
  end

  def top_rated_books(limit \\ 10) do
    Queries.top_rated_books(limit)
  end

  def top_selling_books(limit \\ 50) do
    Queries.top_selling_books(limit)
  end

  def search_books(search_term, page \\ 1, per_page \\ 20) do
    Queries.search_books(search_term, page, per_page)
  end
end
