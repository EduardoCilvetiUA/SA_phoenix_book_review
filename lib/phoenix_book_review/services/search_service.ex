defmodule PhoenixBookReview.Services.SearchService do
  @moduledoc false
  require Logger

  def enabled? do
    System.get_env("ELASTICSEARCH_ENABLED", "false") == "true"
  end

  def search_books(query, page \\ 1, per_page \\ 20) do
    if enabled?() do
      try do
        elasticsearch_search(query, page, per_page)
      rescue
        e -> 
          Logger.error("Elasticsearch search exception: #{inspect(e)}")
          nil
      end
    else
      nil
    end
  end

  def index_book(book) do
    if enabled?() do
      try do
        doc = %{
          id: book.id,
          name: book.name,
          summary: book.summary,
          author_id: book.author_id,
          date_of_publication: book.date_of_publication,
          number_of_sales: book.number_of_sales
        }
        
        url = "#{elasticsearch_url()}/books/_doc/#{book.id}"
        
        case Req.put!(url, json: doc) do
          %{status: status} when status in 200..299 -> 
            :ok
          response -> 
            Logger.error("Elasticsearch index error: #{inspect(response)}")
            :error
        end
      rescue
        e -> 
          Logger.error("Elasticsearch index exception: #{inspect(e)}")
          :error
      end
    else
      :ok
    end
  end

  def index_review(review) do
    if enabled?() do
      try do
        doc = %{
          id: review.id,
          book_id: review.book_id,
          review_text: review.review_text,
          score: review.score,
          upvotes: review.upvotes
        }
        
        url = "#{elasticsearch_url()}/reviews/_doc/#{review.id}"
        
        case Req.put!(url, json: doc) do
          %{status: status} when status in 200..299 -> 
            :ok
          response -> 
            Logger.error("Elasticsearch review index error: #{inspect(response)}")
            :error
        end
      rescue
        e -> 
          Logger.error("Elasticsearch review index exception: #{inspect(e)}")
          :error
      end
    else
      :ok
    end
  end

  def delete_book(book_id) do
    if enabled?() do
      try do
        url = "#{elasticsearch_url()}/books/_doc/#{book_id}"
        Req.delete!(url)
        :ok
      rescue
        _ -> :error
      end
    else
      :ok
    end
  end

  def delete_review(review_id) do
    if enabled?() do
      try do
        url = "#{elasticsearch_url()}/reviews/_doc/#{review_id}"
        Req.delete!(url)
        :ok
      rescue
        _ -> :error
      end
    else
      :ok
    end
  end

  defp elasticsearch_search(query, page, per_page) do
    from = (page - 1) * per_page
    
    search_body = %{
      query: %{
        multi_match: %{
          query: query,
          fields: ["name^2", "summary"],
          type: "best_fields"
        }
      },
      from: from,
      size: per_page
    }

    url = "#{elasticsearch_url()}/books/_search"
    
    case Req.post!(url, json: search_body) do
      %{status: 200, body: %{"hits" => %{"total" => total, "hits" => hits}}} ->
        books = Enum.map(hits, fn hit -> 
          book_data = hit["_source"] |> atomize_keys()
          author_name = get_author_name(book_data.author_id)
          %{book: book_data, author_name: author_name}
        end)
        
        total_value = if is_map(total), do: total["value"], else: total
        
        %{
          books: books,
          page: page,
          per_page: per_page,
          total: total_value,
          total_pages: div(total_value + per_page - 1, per_page)
        }
      response ->
        Logger.error("Elasticsearch search error: #{inspect(response)}")
        nil
    end
  end

  defp elasticsearch_url do
    System.get_env("ELASTICSEARCH_URL", "http://localhost:9200")
  end

  defp atomize_keys(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), v} end)
  end

  defp get_author_name(author_id) do
    case PhoenixBookReview.Repo.get(PhoenixBookReview.Catalog.Author, author_id) do
      nil -> "Unknown Author"
      author -> author.name
    end
  end
end