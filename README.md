# Phoenix Book Review System

A comprehensive book review and analytics platform built with Phoenix Framework. Manage authors, books, reviews, and sales data with advanced analytics capabilities.

## Features

✅ **CRUD Operations**: Authors, Books, Reviews, Sales management  
✅ **Advanced Analytics**: Author statistics, top-rated books, top-selling books  
✅ **Search System**: Book search with pagination  
✅ **Cascade Delete**: Automatic cleanup of related data  
✅ **Mock Data**: 50 real authors, 300 books, reviews, and 5+ years of sales data  
✅ **Responsive Design**: Clean, professional interface  

## Prerequisites

- **Elixir 1.18+** installed
- **Erlang OTP 28+** installed  
- **PostgreSQL** installed and running (for local development)
- **Docker Desktop**

## Quick Start

### Option 1: Local Development

#### 1. Navigate to Project Directory
```bash
cd phoenix_book_review
```

#### 2. Install Dependencies
```bash
mix deps.get
```

#### 3. Configure Environment Variables
Set environment variables in PowerShell:
```powershell
$env:DATABASE_PASSWORD = "yourpassword"
$env:DATABASE_HOST = "localhost" 
$env:SECRET_KEY_BASE = "xDqTau4dWLdp65pr3CC1vTDUh+YRZfYSCe43Uk6W6c0XBOC5MF2qpM70fQMGEF7L"
$env:PHX_PORT = "4000"
```

Or use the provided script:
```powershell
.\run_local.ps1 mix ecto.create
.\run_local.ps1 mix ecto.migrate
.\run_local.ps1 mix run priv/repo/seeds.exs
.\run_local.ps1 mix phx.server
```

#### 4. Setup Database
```bash
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
```

#### 5. Start Server
```bash
mix phx.server
```

### Option 2: Docker Deployment (Recommended)

#### 1. Ensure Environment Variables
Update `.env` file:
```env
DATABASE_PASSWORD=yourpassword
DATABASE_HOST=db
SECRET_KEY_BASE=xDqTau4dWLdp65pr3CC1vTDUh+YRZfYSCe43Uk6W6c0XBOC5MF2qpM70fQMGEF7L
PHX_PORT=4000
MIX_ENV=dev
```

#### 2. Start with Docker Compose
```bash
docker-compose up --build
```

This will:
- Start PostgreSQL database container
- Build and start Phoenix application container
- Automatically run migrations and seed data
- Make the application available at http://localhost:4000

## Application URLs

### Main Application
- **Homepage**: http://localhost:4000/
- **Analytics Dashboard**: http://localhost:4000/analytics

### CRUD Management
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

## Mock Data Generated

- **50 Real Authors**: Famous authors with accurate birth years and countries
- **300 Books**: Varied titles with publication dates from different years
- **1-10 Reviews per Book**: Realistic review scores and content
- **5-15 Years Sales Data**: Historical sales data for comprehensive analytics

## Docker Commands

```bash
# Start services
docker-compose up --build

# Start in background
docker-compose up --build -d

# View logs
docker-compose logs web
docker-compose logs db

# Stop services
docker-compose down

# Reset everything (removes volumes)
docker-compose down -v

# Execute commands in container
docker-compose exec web mix ecto.reset
```

## Troubleshooting

### Local Development Issues
- **Database Connection**: Ensure PostgreSQL is running and DATABASE_PASSWORD is set
- **Permission Errors**: Remove `_build/` and `deps/` directories if they contain Docker files
- **Port 4000 in Use**: Change PHX_PORT environment variable

### Docker Issues
- **Build Errors**: Run `docker-compose build --no-cache`
- **Database Issues**: Check if containers are healthy with `docker-compose ps`
- **Environment Variables**: Verify `.env` file has correct values

## File Structure

```
phoenix_book_review/
├── lib/phoenix_book_review/catalog/     # Business logic
├── lib/phoenix_book_review_web/         # Web interface
├── priv/repo/migrations/                # Database migrations
├── priv/repo/seeds.exs                  # Mock data generation
├── assets/css/custom.css                # Custom styling
├── docker-compose.yml                   # Docker configuration
├── Dockerfile                           # Container setup
├── .env                                 # Environment variables
```

## Technology Stack

- **Backend**: Phoenix Framework (Elixir)
- **Database**: PostgreSQL
- **Frontend**: Phoenix HTML + TailwindCSS + DaisyUI
- **Deployment**: Docker + Docker Compose
- **Analytics**: Custom Ecto queries with aggregations
