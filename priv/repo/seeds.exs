alias PhoenixBookReview.Repo
alias PhoenixBookReview.Catalog.{Author, Book, Review, Sales}


real_authors = [
  %{name: "Stephen King", country: "United States", birth_year: 1947, genre: "Horror"},
  %{name: "J.K. Rowling", country: "United Kingdom", birth_year: 1965, genre: "Fantasy"},
  %{name: "George R.R. Martin", country: "United States", birth_year: 1948, genre: "Fantasy"},
  %{name: "Agatha Christie", country: "United Kingdom", birth_year: 1890, genre: "Mystery"},
  %{name: "Ernest Hemingway", country: "United States", birth_year: 1899, genre: "Literature"},
  %{name: "F. Scott Fitzgerald", country: "United States", birth_year: 1896, genre: "Literature"},
  %{name: "Jane Austen", country: "United Kingdom", birth_year: 1775, genre: "Romance"},
  %{name: "Charles Dickens", country: "United Kingdom", birth_year: 1812, genre: "Literature"},
  %{name: "Mark Twain", country: "United States", birth_year: 1835, genre: "Literature"},
  %{name: "William Shakespeare", country: "United Kingdom", birth_year: 1564, genre: "Drama"},
  %{name: "Virginia Woolf", country: "United Kingdom", birth_year: 1882, genre: "Literature"},
  %{name: "Harper Lee", country: "United States", birth_year: 1926, genre: "Literature"},
  %{name: "George Orwell", country: "United Kingdom", birth_year: 1903, genre: "Dystopian"},
  %{name: "Toni Morrison", country: "United States", birth_year: 1931, genre: "Literature"},
  %{name: "Maya Angelou", country: "United States", birth_year: 1928, genre: "Biography"},
  %{name: "Margaret Atwood", country: "Canada", birth_year: 1939, genre: "Dystopian"},
  %{name: "Neil Gaiman", country: "United Kingdom", birth_year: 1960, genre: "Fantasy"},
  %{name: "Paulo Coelho", country: "Brazil", birth_year: 1947, genre: "Philosophy"},
  %{name: "Dan Brown", country: "United States", birth_year: 1964, genre: "Thriller"},
  %{name: "John Steinbeck", country: "United States", birth_year: 1902, genre: "Literature"},
  %{name: "Edgar Allan Poe", country: "United States", birth_year: 1809, genre: "Horror"},
  %{name: "Arthur Conan Doyle", country: "United Kingdom", birth_year: 1859, genre: "Mystery"},
  %{name: "H.P. Lovecraft", country: "United States", birth_year: 1890, genre: "Horror"},
  %{name: "Isaac Asimov", country: "United States", birth_year: 1920, genre: "Science Fiction"},
  %{name: "Ray Bradbury", country: "United States", birth_year: 1920, genre: "Science Fiction"},
  %{name: "Aldous Huxley", country: "United Kingdom", birth_year: 1894, genre: "Dystopian"},
  %{name: "Oscar Wilde", country: "Ireland", birth_year: 1854, genre: "Literature"},
  %{name: "Leo Tolstoy", country: "Russia", birth_year: 1828, genre: "Literature"},
  %{name: "Fyodor Dostoevsky", country: "Russia", birth_year: 1821, genre: "Literature"},
  %{name: "Gabriel Garcia Marquez", country: "Colombia", birth_year: 1927, genre: "Magical Realism"},
  %{name: "Haruki Murakami", country: "Japan", birth_year: 1949, genre: "Magical Realism"},
  %{name: "Salman Rushdie", country: "India", birth_year: 1947, genre: "Magical Realism"},
  %{name: "Kurt Vonnegut", country: "United States", birth_year: 1922, genre: "Satire"},
  %{name: "Douglas Adams", country: "United Kingdom", birth_year: 1952, genre: "Comedy"},
  %{name: "Terry Pratchett", country: "United Kingdom", birth_year: 1948, genre: "Fantasy"},
  %{name: "Ursula K. Le Guin", country: "United States", birth_year: 1929, genre: "Science Fiction"},
  %{name: "Philip K. Dick", country: "United States", birth_year: 1928, genre: "Science Fiction"},
  %{name: "William Gibson", country: "Canada", birth_year: 1948, genre: "Cyberpunk"},
  %{name: "Octavia Butler", country: "United States", birth_year: 1947, genre: "Science Fiction"},
  %{name: "Chinua Achebe", country: "Nigeria", birth_year: 1930, genre: "Literature"},
  %{name: "Zora Neale Hurston", country: "United States", birth_year: 1891, genre: "Literature"},
  %{name: "James Baldwin", country: "United States", birth_year: 1924, genre: "Literature"},
  %{name: "Langston Hughes", country: "United States", birth_year: 1901, genre: "Poetry"},
  %{name: "Ralph Ellison", country: "United States", birth_year: 1914, genre: "Literature"},
  %{name: "Flannery O'Connor", country: "United States", birth_year: 1925, genre: "Literature"},
  %{name: "Sylvia Plath", country: "United States", birth_year: 1932, genre: "Poetry"},
  %{name: "Anne Rice", country: "United States", birth_year: 1941, genre: "Horror"},
  %{name: "Michael Crichton", country: "United States", birth_year: 1942, genre: "Thriller"},
  %{name: "Tom Clancy", country: "United States", birth_year: 1947, genre: "Thriller"},
  %{name: "John Grisham", country: "United States", birth_year: 1955, genre: "Legal Thriller"}
]

IO.puts("Seeding 50 authors...")
authors = Enum.map(real_authors, fn author_info ->
  %Author{}
  |> Author.changeset(%{
    name: author_info.name,
    date_of_birth: Date.new!(author_info.birth_year, 6, 15),
    country_of_origin: author_info.country,
    description: "Acclaimed #{author_info.genre} author known for masterful storytelling"
  })
  |> Repo.insert!()
end)

book_titles = [
  "The Silent Storm", "Midnight's Echo", "Crimson Dawn", "The Last Guardian", "Shadows of Tomorrow",
  "The Forgotten Key", "Whispers in Time", "The Golden Thread", "Beneath the Stars", "The Hidden Path",
  "Echoes of Eternity", "The Silver Crown", "Dancing with Destiny", "The Broken Mirror", "Songs of the Wind",
  "The Crystal Mountain", "Fires of the Heart", "The Endless Journey", "Secrets of the Deep", "The Phoenix Rising",
  "The Moonlit Garden", "Voices from Beyond", "The Jade Empire", "Letters from the Past", "Dreams of Tomorrow",
  "The Iron Throne", "Whispers of the Past", "The Diamond Quest", "Shadows and Light", "The Emerald City",
  "The Clockwork Heart", "Rivers of Time", "The Glass Castle", "Wings of Freedom", "The Copper Crown",
  "The Starlight Express", "Mysteries of the Night", "The Golden Dawn", "The Silver Stream", "The Purple Haze",
  "The Black Rose", "The White Wolf", "The Blue Moon", "The Red Dragon", "The Green Valley",
  "The Yellow Sun", "The Orange Sunset", "The Pink Pearl", "The Gray Ghost", "The Brown Earth",
  "Beyond the Horizon", "Into the Void", "Through the Looking Glass", "Across the Universe", "Under the Ocean",
  "Above the Clouds", "Behind the Curtain", "Within the Maze", "Around the Corner", "Between the Lines",
  "Against the Odds", "Before the Dawn", "After the Storm", "During the Night", "Throughout the Ages",
  "Alongside the River", "Beneath the Surface", "Beyond the Veil", "Inside the Mind", "Outside the Box",
  "The Ancient Code", "The Modern World", "The Future Past", "The Present Moment", "The Eternal Flame",
  "The Broken Chain", "The Golden Circle", "The Silver Thread", "The Bronze Key", "The Iron Gate",
  "The Crystal Cave", "The Diamond Mine", "The Ruby Heart", "The Sapphire Eyes", "The Emerald Forest",
  "The Obsidian Tower", "The Marble Hall", "The Granite Mountain", "The Limestone Valley", "The Sandstone Desert",
  "The Velvet Night", "The Silk Road", "The Cotton Field", "The Wool Blanket", "The Leather Boots",
  "The Paper Trail", "The Digital Age", "The Analog World", "The Virtual Reality", "The Augmented Truth",
  "The Quantum Leap", "The Binary Code", "The Hexadecimal Key", "The ASCII Art", "The Unicode Standard",
  "The HTML Document", "The CSS Style", "The JavaScript Function", "The Python Script", "The Ruby Gem",
  "The Java Class", "The C++ Program", "The Assembly Language", "The Machine Code", "The Operating System"
]

summaries = [
  "A gripping tale of adventure and discovery in a world beyond imagination",
  "An epic journey through time and space that will leave you breathless",
  "A heart-warming story of love, loss, and redemption",
  "A thrilling mystery that keeps you guessing until the very end",
  "An inspiring story of courage and determination against all odds",
  "A beautiful exploration of human nature and the power of hope",
  "A captivating story that weaves together past and present",
  "An unforgettable adventure through magical realms and distant lands",
  "A powerful tale of friendship and loyalty in the face of adversity",
  "A mesmerizing story that explores the depths of the human soul",
  "A thought-provoking examination of society and its complexities",
  "An emotional rollercoaster that touches the heart and mind",
  "A masterful blend of action, drama, and intrigue",
  "A compelling narrative that challenges conventional wisdom",
  "A rich tapestry of characters and interconnected storylines"
]

IO.puts("Seeding 300 books...")
books = Enum.map(1..300, fn i ->
  author = Enum.random(authors)
  pub_year = 1950 + :rand.uniform(74)
  
  title = Enum.at(book_titles, rem(i - 1, length(book_titles)))
  unique_title = if i > length(book_titles), do: "#{title} Volume #{div(i - 1, length(book_titles)) + 1}", else: title
  
  %Book{}
  |> Book.changeset(%{
    name: unique_title,
    summary: Enum.random(summaries),
    date_of_publication: Date.new!(pub_year, 3, 15),
    number_of_sales: :rand.uniform(10000000) + 5000,
    author_id: author.id
  })
  |> Repo.insert!()
end)

review_texts = [
  "A masterpiece of storytelling that captivated me from beginning to end.",
  "Exceptional character development and a gripping narrative.",
  "One of the finest works I've ever read. Highly recommended.",
  "The author's prose is both beautiful and powerful.",
  "A thought-provoking read that stays with you long after finishing.",
  "Brilliantly crafted with unexpected twists and turns.",
  "Rich in detail and emotion. A truly remarkable book.",
  "The depth of this work is extraordinary. A must-read.",
  "Compelling storytelling with well-developed characters.",
  "An engaging and insightful exploration of human nature.",
  "The writing style is captivating and the plot is well-constructed.",
  "A book that challenges your perspective and makes you think deeply.",
  "Outstanding work with excellent pacing and character arcs.",
  "The author has created a vivid and immersive world.",
  "A timeless story that deserves all the praise it receives.",
  "Incredible attention to detail and masterful world-building.",
  "The characters feel real and their struggles are deeply moving.",
  "A perfect blend of entertainment and literary excellence.",
  "This book changed my perspective on life and humanity.",
  "Absolutely brilliant from start to finish. Could not put it down."
]

IO.puts("Seeding reviews (1-10 per book)...")
Enum.each(books, fn book ->
  review_count = 1 + :rand.uniform(10)
  
  Enum.each(1..review_count, fn _ ->
    %Review{}
    |> Review.changeset(%{
      book_id: book.id,
      review_text: Enum.random(review_texts),
      score: :rand.uniform(5),
      upvotes: :rand.uniform(200)
    })
    |> Repo.insert!()
  end)
end)

IO.puts("Seeding sales data (5+ years per book)...")
current_year = Date.utc_today().year
Enum.each(books, fn book ->
  years_count = 5 + :rand.uniform(10)
  start_year = current_year - years_count
  
  Enum.each(start_year..current_year, fn year ->
    %Sales{}
    |> Sales.changeset(%{
      book_id: book.id,
      year: year,
      sales_amount: :rand.uniform(250000) + 1000
    })
    |> Repo.insert!()
  end)
end)

IO.puts("Seed data created successfully!")
IO.puts("Created:")
IO.puts("- 50 real authors with accurate birth years and countries")
IO.puts("- 300 books with varied titles and publication dates")  
IO.puts("- 1-10 reviews per book")
IO.puts("- 5-15 years of sales data per book")