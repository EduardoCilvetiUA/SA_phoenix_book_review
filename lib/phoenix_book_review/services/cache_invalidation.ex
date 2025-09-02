defmodule PhoenixBookReview.Services.CacheInvalidation do
  alias PhoenixBookReview.Services.CacheService

  def invalidate_author_caches do
    CacheService.delete_pattern("authors_stats_*")
  end

  def invalidate_book_caches do
    CacheService.delete_pattern("top_rated_books_*")
    CacheService.delete_pattern("top_selling_books_*")
    CacheService.delete_pattern("search_books_*")
  end

  def invalidate_review_caches do
    CacheService.delete_pattern("authors_stats_*")
    CacheService.delete_pattern("top_rated_books_*")
  end

  def invalidate_sales_caches do
    CacheService.delete_pattern("authors_stats_*")
    CacheService.delete_pattern("top_selling_books_*")
  end

  def invalidate_all_caches do
    CacheService.delete_pattern("authors_stats_*")
    CacheService.delete_pattern("top_rated_books_*")
    CacheService.delete_pattern("top_selling_books_*")
    CacheService.delete_pattern("search_books_*")
  end
end