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

### 2. Environment Configuration
Create a `.env` file in the project root with your database credentials:
```bash
cp .env.example .env
```
Then edit `.env` and update:
```
DATABASE_PASSWORD=your_postgres_password
SECRET_KEY_BASE=your_secret_key_base
PHX_PORT=4000
```

**Note**: The application automatically loads the `.env` file in development mode. No manual environment variable loading is required.

### 3. Install Dependencies
```bash
mix deps.get
```

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
- Check DATABASE_PASSWORD in .env file
- Verify database exists
- Ensure environment variables are loaded

### Port Already in Use
```bash
# Kill process on port 4000
lsof -ti:4000 | xargs kill -9
```

### Permission Issues
- Ensure proper PostgreSQL user permissions
- Check file system permissions