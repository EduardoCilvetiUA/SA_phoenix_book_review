defmodule PhoenixBookReview.Application do
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixBookReviewWeb.Telemetry,
      PhoenixBookReview.Repo,
      {DNSCluster, query: Application.get_env(:phoenix_book_review, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixBookReview.PubSub},
      PhoenixBookReviewWeb.Endpoint
    ] ++ redis_children()

    opts = [strategy: :one_for_one, name: PhoenixBookReview.Supervisor]

    result = Supervisor.start_link(children, opts)

    # Test Redis connection after startup
    test_redis_connection()

    initialize_elasticsearch()

    result
  end

  defp redis_children do
    if System.get_env("REDIS_ENABLED", "false") == "true" do
      redis_url = System.get_env("REDIS_URL")
      Logger.info("Enabling Redis connection with URL: #{redis_url}")
      [{Redix, {redis_url, [name: :redix]}}]
    else
      Logger.info("Redis is disabled (REDIS_ENABLED=false)")
      []
    end
  end

  defp test_redis_connection do
    if System.get_env("REDIS_ENABLED", "false") == "true" do
      Task.start(fn ->
        :timer.sleep(2000) # Wait for Redis to be ready
        Logger.info("Testing Redis connection...")
        
        case Redix.command(:redix, ["PING"]) do
          {:ok, "PONG"} -> 
            Logger.info("Redis connection successful")
            # Test set/get operations
            test_key = "connection_test_#{:os.system_time(:millisecond)}"
            test_value = %{test: "data", timestamp: :os.system_time(:second)}
            
            case PhoenixBookReview.Services.CacheService.set(test_key, test_value, 60) do
              :ok -> 
                Logger.info("Redis SET operation successful")
                case PhoenixBookReview.Services.CacheService.get(test_key) do
                  nil -> Logger.error("Redis GET operation failed - returned nil")
                  result -> Logger.info("Redis GET operation successful - received: #{inspect(result)}")
                end
              :error -> Logger.error("Redis SET operation failed")
            end
            
          {:error, reason} -> 
            Logger.error("Redis connection failed: #{inspect(reason)}")
        end
      end)
    end
  end

  defp initialize_elasticsearch do
    if System.get_env("ELASTICSEARCH_ENABLED", "false") == "true" do
      Task.start(fn ->
        :timer.sleep(5000)
        PhoenixBookReview.Services.SearchIndexer.create_indices()
        PhoenixBookReview.Services.SearchIndexer.reindex_all_books()
        PhoenixBookReview.Services.SearchIndexer.reindex_all_reviews()
      end)
    end
  end

  @impl true
  def config_change(changed, _new, removed) do
    PhoenixBookReviewWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
