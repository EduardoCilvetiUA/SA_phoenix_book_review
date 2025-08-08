defmodule PhoenixBookReview.Catalog.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :review_text, :string
    field :score, :integer
    field :upvotes, :integer, default: 0
    belongs_to :book, PhoenixBookReview.Catalog.Book

    timestamps()
  end

  def changeset(review, attrs) do
    review
    |> cast(attrs, [:review_text, :score, :upvotes, :book_id])
    |> validate_required([:review_text, :score, :book_id])
    |> validate_number(:score, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_number(:upvotes, greater_than_or_equal_to: 0)
  end
end