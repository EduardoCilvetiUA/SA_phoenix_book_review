defmodule PhoenixBookReview.Services.SearchIndexer do
  @moduledoc false
  require Logger
  alias PhoenixBookReview.Services.SearchService

  def create_indices do
    if SearchService.enabled?() do
      create_books_index()
      create_reviews_index()
    end
  end

  def reindex_all_books do
    if SearchService.enabled?() do
      
      PhoenixBookReview.Catalog.list_books()
      |> Enum.each(&SearchService.index_book/1)
      
    end
  end

  def reindex_all_reviews do
    if SearchService.enabled?() do
      
      PhoenixBookReview.Catalog.list_reviews()
      |> Enum.each(&SearchService.index_review/1)
      
    end
  end

  defp create_books_index do
    try do
      mapping = %{
        mappings: %{
          properties: %{
            id: %{type: "integer"},
            name: %{type: "text", analyzer: "standard"},
            summary: %{type: "text", analyzer: "standard"},
            author_id: %{type: "integer"},
            date_of_publication: %{type: "date"},
            number_of_sales: %{type: "integer"}
          }
        }
      }

      url = "#{elasticsearch_url()}/books"
      
      case Req.put!(url, json: mapping) do
        %{status: status} when status in 200..299 -> 
          :ok
        response -> 
          :error
      end
    rescue
      e -> nil
    end
  end

  defp create_reviews_index do
    try do
      mapping = %{
        mappings: %{
          properties: %{
            id: %{type: "integer"},
            book_id: %{type: "integer"},
            review_text: %{type: "text", analyzer: "standard"},
            score: %{type: "float"},
            upvotes: %{type: "integer"}
          }
        }
      }

      url = "#{elasticsearch_url()}/reviews"
      
      case Req.put!(url, json: mapping) do
        %{status: status} when status in 200..299 -> 
          :ok
        response -> 
          :error
      end
    rescue
      e -> nil
    end
  end

  defp elasticsearch_url do
    System.get_env("ELASTICSEARCH_URL", "http://localhost:9200")
  end
end