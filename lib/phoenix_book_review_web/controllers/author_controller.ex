defmodule PhoenixBookReviewWeb.AuthorController do
  use PhoenixBookReviewWeb, :controller

  alias PhoenixBookReview.Catalog
  alias PhoenixBookReview.Catalog.Author
  alias PhoenixBookReview.Services.FileUpload

  def index(conn, _params) do
    authors = Catalog.list_authors()
    render(conn, :index, authors: authors)
  end

  def show(conn, %{"id" => id}) do
    author = Catalog.get_author!(id)
    render(conn, :show, author: author)
  end

  def new(conn, _params) do
    changeset = Catalog.change_author(%Author{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"author" => author_params}) do
    author_params = handle_image_upload(author_params, "profile_image_upload")
    
    case Catalog.create_author(author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author created successfully.")
        |> redirect(to: ~p"/authors/#{author}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    author = Catalog.get_author!(id)
    changeset = Catalog.change_author(author)
    render(conn, :edit, author: author, changeset: changeset)
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Catalog.get_author!(id)
    author_params = handle_image_upload(author_params, "profile_image_upload")

    case Catalog.update_author(author, author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author updated successfully.")
        |> redirect(to: ~p"/authors/#{author}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, author: author, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Catalog.get_author!(id)
    
    case Catalog.delete_author(author) do
      {:ok, _result} ->
        conn
        |> put_flash(:info, "Author and all related books, reviews, and sales deleted successfully.")
        |> redirect(to: ~p"/authors")
      
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error deleting author.")
        |> redirect(to: ~p"/authors")
    end
  end

  defp handle_image_upload(params, upload_key) do
    case Map.get(params, upload_key) do
      %Plug.Upload{} = upload ->
        case FileUpload.handle_upload(upload, "author_profile") do
          {:ok, path} -> Map.put(params, "profile_image", path)
          {:error, _} -> params
        end
      _ -> params
    end
  end
end