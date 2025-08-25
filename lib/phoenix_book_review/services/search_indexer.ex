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
      Logger.info("Indexing books in Elasticsearch...")
      
      PhoenixBookReview.Catalog.list_books()
      |> Enum.each(&SearchService.index_book/1)
      
      Logger.info("Books indexing completed")
    end
  end

  def reindex_all_reviews do
    if SearchService.enabled?() do
      Logger.info("Indexing reviews in Elasticsearch...")
      
      PhoenixBookReview.Catalog.list_reviews()
      |> Enum.each(&SearchService.index_review/1)
      
      Logger.info("Reviews indexing completed")
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
          Logger.info("Books index created successfully")
        response -> 
          Logger.warn("Books index creation: #{inspect(response)}")
      end
    rescue
      e -> Logger.error("Books index creation exception: #{inspect(e)}")
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
          Logger.info("Reviews index created successfully")
        response -> 
          Logger.warn("Reviews index creation: #{inspect(response)}")
      end
    rescue
      e -> Logger.error("Reviews index creation exception: #{inspect(e)}")
    end
  end

  defp elasticsearch_url do
    System.get_env("ELASTICSEARCH_URL", "http://localhost:9200")
  end
end