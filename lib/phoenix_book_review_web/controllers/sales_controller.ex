defmodule PhoenixBookReviewWeb.SalesController do
  use PhoenixBookReviewWeb, :controller

  alias PhoenixBookReview.Catalog
  alias PhoenixBookReview.Catalog.Sales

  def index(conn, _params) do
    sales = Catalog.list_sales()
    render(conn, :index, sales: sales)
  end

  def show(conn, %{"id" => id}) do
    sales = Catalog.get_sales!(id)
    render(conn, :show, sales: sales)
  end

  def new(conn, _params) do
    changeset = Catalog.change_sales(%Sales{})
    books = Catalog.list_books()
    render(conn, :new, changeset: changeset, books: books)
  end

  def create(conn, %{"sales" => sales_params}) do
    case Catalog.create_sales(sales_params) do
      {:ok, sales} ->
        conn
        |> put_flash(:info, "Sales created successfully.")
        |> redirect(to: ~p"/sales/#{sales}")

      {:error, %Ecto.Changeset{} = changeset} ->
        books = Catalog.list_books()
        render(conn, :new, changeset: changeset, books: books)
    end
  end

  def edit(conn, %{"id" => id}) do
    sales = Catalog.get_sales!(id)
    changeset = Catalog.change_sales(sales)
    books = Catalog.list_books()
    render(conn, :edit, sales: sales, changeset: changeset, books: books)
  end

  def update(conn, %{"id" => id, "sales" => sales_params}) do
    sales = Catalog.get_sales!(id)

    case Catalog.update_sales(sales, sales_params) do
      {:ok, sales} ->
        conn
        |> put_flash(:info, "Sales updated successfully.")
        |> redirect(to: ~p"/sales/#{sales}")

      {:error, %Ecto.Changeset{} = changeset} ->
        books = Catalog.list_books()
        render(conn, :edit, sales: sales, changeset: changeset, books: books)
    end
  end

  def delete(conn, %{"id" => id}) do
    sales = Catalog.get_sales!(id)
    {:ok, _sales} = Catalog.delete_sales(sales)

    conn
    |> put_flash(:info, "Sales deleted successfully.")
    |> redirect(to: ~p"/sales")
  end
end