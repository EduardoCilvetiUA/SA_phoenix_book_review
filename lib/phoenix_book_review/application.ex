defmodule PhoenixBookReview.Application do
  @moduledoc false

  use Application

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
    Supervisor.start_link(children, opts)
  end

  defp redis_children do
    if System.get_env("REDIS_ENABLED", "false") == "true" do
      redis_url = System.get_env("REDIS_URL", "redis://localhost:6379/0")
      [{Redix, {redis_url, [name: :redix]}}]
    else
      []
    end
  end

  @impl true
  def config_change(changed, _new, removed) do
    PhoenixBookReviewWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end