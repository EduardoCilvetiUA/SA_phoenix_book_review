alias PhoenixBookReview.Repo
alias PhoenixBookReview.Catalog.{Author, Book, Review, Sales}

authors_data = [
  %{name: "J.K. Rowling", date_of_birth: ~D[1965-07-31], country_of_origin: "United Kingdom", description: "British author best known for the Harry Potter series"},
  %{name: "George R.R. Martin", date_of_birth: ~D[1948-09-20], country_of_origin: "United States", description: "American novelist and short story writer"},
  %{name: "Stephen King", date_of_birth: ~D[1947-09-21], country_of_origin: "United States", description: "American author of horror, supernatural fiction, suspense"},
  %{name: "Agatha Christie", date_of_birth: ~D[1890-09-15], country_of_origin: "United Kingdom", description: "British writer known for detective novels"},
  %{name: "Dan Brown", date_of_birth: ~D[1964-06-22], country_of_origin: "United States", description: "American author of thriller fiction"},
  %{name: "Paulo Coelho", date_of_birth: ~D[1947-08-24], country_of_origin: "Brazil", description: "Brazilian lyricist and novelist"},
  %{name: "Margaret Atwood", date_of_birth: ~D[1939-11-18], country_of_origin: "Canada", description: "Canadian poet, novelist, literary critic"},
  %{name: "Neil Gaiman", date_of_birth: ~D[1960-11-10], country_of_origin: "United Kingdom", description: "British author of short fiction, novels, comic books"},
  %{name: "Haruki Murakami", date_of_birth: ~D[1949-01-12], country_of_origin: "Japan", description: "Japanese writer known for surreal fiction"},
  %{name: "Toni Morrison", date_of_birth: ~D[1931-02-18], country_of_origin: "United States", description: "American novelist, essayist, editor"}
]

books_data = [
  %{name: "Harry Potter and the Philosopher's Stone", summary: "A young wizard discovers his magical heritage", date_of_publication: ~D[1997-06-26], number_of_sales: 120000000},
  %{name: "A Game of Thrones", summary: "Epic fantasy novel set in the fictional world of Westeros", date_of_publication: ~D[1996-08-01], number_of_sales: 15000000},
  %{name: "The Shining", summary: "Horror novel about a writer's descent into madness", date_of_publication: ~D[1977-01-28], number_of_sales: 692000},
  %{name: "Murder on the Orient Express", summary: "Detective novel featuring Hercule Poirot", date_of_publication: ~D[1934-01-01], number_of_sales: 8000000},
  %{name: "The Da Vinci Code", summary: "Mystery thriller involving religious history", date_of_publication: ~D[2003-03-18], number_of_sales: 80000000}
]

IO.puts("Seeding authors...")
authors = Enum.map(authors_data, fn author_attrs ->
  %Author{}
  |> Author.changeset(author_attrs)
  |> Repo.insert!()
end)

IO.puts("Seeding books...")
books = Enum.map(Enum.with_index(books_data), fn {book_attrs, index} ->
  author = Enum.at(authors, rem(index, length(authors)))
  book_attrs_with_author = Map.put(book_attrs, :author_id, author.id)
  
  %Book{}
  |> Book.changeset(book_attrs_with_author)
  |> Repo.insert!()
end)

IO.puts("Seeding reviews...")
Enum.each(books, fn book ->
  review_count = :rand.uniform(10)
  
  Enum.each(1..review_count, fn _ ->
    %Review{}
    |> Review.changeset(%{
      book_id: book.id,
      review_text: "Great book with amazing story and characters. Highly recommended!",
      score: :rand.uniform(5),
      upvotes: :rand.uniform(100)
    })
    |> Repo.insert!()
  end)
end)

IO.puts("Seeding sales data...")
Enum.each(books, fn book ->
  Enum.each(2019..2024, fn year ->
    %Sales{}
    |> Sales.changeset(%{
      book_id: book.id,
      year: year,
      sales_amount: :rand.uniform(50000) + 1000
    })
    |> Repo.insert!()
  end)
end)

IO.puts("Seed data created successfully!")