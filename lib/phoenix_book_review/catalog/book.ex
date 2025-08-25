defmodule PhoenixBookReview.Catalog.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :summary, :date_of_publication, :number_of_sales, :author_id, :cover_image, :inserted_at, :updated_at]}
  schema "books" do
    field :name, :string
    field :summary, :string
    field :date_of_publication, :date
    field :number_of_sales, :integer
    field :cover_image, :string
    belongs_to :author, PhoenixBookReview.Catalog.Author
    has_many :reviews, PhoenixBookReview.Catalog.Review
    has_many :sales, PhoenixBookReview.Catalog.Sales

    timestamps()
  end

  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name, :summary, :date_of_publication, :number_of_sales, :author_id, :cover_image])
    |> validate_required([:name, :summary, :date_of_publication, :number_of_sales, :author_id])
  end
end