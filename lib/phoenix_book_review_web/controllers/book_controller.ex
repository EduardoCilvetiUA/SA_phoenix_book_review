defmodule PhoenixBookReviewWeb.BookController do
  use PhoenixBookReviewWeb, :controller

  alias PhoenixBookReview.Catalog
  alias PhoenixBookReview.Catalog.Book

  def index(conn, _params) do
    books = Catalog.list_books()
    render(conn, :index, books: books)
  end

  def show(conn, %{"id" => id}) do
    book = Catalog.get_book!(id)
    render(conn, :show, book: book)
  end

  def new(conn, _params) do
    changeset = Catalog.change_book(%Book{})
    authors = Catalog.list_authors()
    render(conn, :new, changeset: changeset, authors: authors)
  end

  def create(conn, %{"book" => book_params}) do
    case Catalog.create_book(book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: ~p"/books/#{book}")

      {:error, %Ecto.Changeset{} = changeset} ->
        authors = Catalog.list_authors()
        render(conn, :new, changeset: changeset, authors: authors)
    end
  end

  def edit(conn, %{"id" => id}) do
    book = Catalog.get_book!(id)
    changeset = Catalog.change_book(book)
    authors = Catalog.list_authors()
    render(conn, :edit, book: book, changeset: changeset, authors: authors)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Catalog.get_book!(id)

    case Catalog.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: ~p"/books/#{book}")

      {:error, %Ecto.Changeset{} = changeset} ->
        authors = Catalog.list_authors()
        render(conn, :edit, book: book, changeset: changeset, authors: authors)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Catalog.get_book!(id)
    
    case Catalog.delete_book(book) do
      {:ok, _result} ->
        conn
        |> put_flash(:info, "Book and all related reviews and sales deleted successfully.")
        |> redirect(to: ~p"/books")
      
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error deleting book.")
        |> redirect(to: ~p"/books")
    end
  end
end