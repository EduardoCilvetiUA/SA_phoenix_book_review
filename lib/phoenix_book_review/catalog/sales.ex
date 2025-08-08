defmodule PhoenixBookReview.Catalog.Sales do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales" do
    field :year, :integer
    field :sales_amount, :integer
    belongs_to :book, PhoenixBookReview.Catalog.Book

    timestamps()
  end

  def changeset(sales, attrs) do
    sales
    |> cast(attrs, [:year, :sales_amount, :book_id])
    |> validate_required([:year, :sales_amount, :book_id])
    |> validate_number(:year, greater_than: 1900)
    |> validate_number(:sales_amount, greater_than_or_equal_to: 0)
  end
end