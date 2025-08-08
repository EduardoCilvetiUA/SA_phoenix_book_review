defmodule PhoenixBookReview.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_book_review,
    adapter: Ecto.Adapters.Postgres
end
