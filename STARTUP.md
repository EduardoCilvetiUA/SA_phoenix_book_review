# Phoenix Book Review Application - Startup Guide

## Prerequisites
- Elixir 1.18+ installed
- Erlang OTP 28+ installed  
- PostgreSQL installed and running
- Phoenix framework installed

## Setup Instructions

### 1. Navigate to Project Directory
```bash
cd D:\Usuario\Escritorio\Uandes\SoftwareArquitecture\phoenix_book_review\phoenix_book_review
```

### 2. Install Dependencies
```bash
mix deps.get
```

### 3. Configure Database
Update `config/dev.exs` if needed:
- Username: postgres
- Password: 2503 (or your PostgreSQL password)
- Database: phoenix_book_review_dev
- Host: localhost

### 4. Create and Migrate Database
```bash
mix ecto.create
mix ecto.migrate
```

### 5. Seed Database with Mock Data
```bash
mix run priv/repo/seeds.exs
```

### 6. Start Phoenix Server
```bash
mix phx.server
```

## Accessing the Application

### Main URLs
- **Homepage**: http://localhost:4000/
- **Analytics Dashboard**: http://localhost:4000/analytics

### CRUD Operations
- **Authors**: http://localhost:4000/authors
- **Books**: http://localhost:4000/books
- **Reviews**: http://localhost:4000/reviews
- **Sales**: http://localhost:4000/sales

### Analytics Views
- **Authors Statistics**: http://localhost:4000/analytics/authors_stats
- **Top 10 Rated Books**: http://localhost:4000/analytics/top_rated_books
- **Top 50 Selling Books**: http://localhost:4000/analytics/top_selling_books
- **Search Books**: http://localhost:4000/analytics/search

### Development Tools
- **LiveDashboard**: http://localhost:4000/dev/dashboard

## Features Available

### Basic CRUD
✅ Authors management
✅ Books management  
✅ Reviews management
✅ Sales management

### Advanced Analytics
✅ Authors table with sorting/filtering
✅ Top-rated books ranking
✅ Top-selling books ranking
✅ Book search with pagination

### Mock Data
✅ 10 authors with realistic data
✅ 5 books with various genres
✅ Random reviews (1-10 per book)
✅ 6 years of sales data (2019-2024)

## Troubleshooting

### Database Connection Issues
- Ensure PostgreSQL is running
- Check password in config/dev.exs
- Verify database exists

### Port Already in Use
```bash
# Kill process on port 4000
lsof -ti:4000 | xargs kill -9
```

### Permission Issues
- Ensure proper PostgreSQL user permissions
- Check file system permissions

## Code Standards Compliance
✅ All files under 100 lines
✅ No comments in code
✅ No emojis
✅ Clean English naming
✅ Single responsibility per module