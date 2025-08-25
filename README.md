# Phoenix Book Review System

A comprehensive book review and analytics platform built with Phoenix Framework. Manage authors, books, reviews, and sales data with advanced analytics capabilities and Redis caching.

## Features

✅ **CRUD Operations**: Authors, Books, Reviews, Sales management  
✅ **Advanced Analytics**: Author statistics, top-rated books, top-selling books  
✅ **Redis Cache Layer**: 2-21x performance boost with graceful fallback  
✅ **Search System**: Book search with pagination  
✅ **Cascade Delete**: Automatic cleanup of related data  
✅ **Mock Data**: 50 real authors, 300 books, reviews, and 5+ years of sales data  
✅ **Responsive Design**: Clean, professional interface  

## Prerequisites

- **Elixir 1.18+** installed
- **Erlang OTP 28+** installed  
- **PostgreSQL** installed and running (for local development)
- **Docker Desktop**
- **Redis** (optional - for caching)

## Quick Start

### Option 1: Local Development (Without Cache)

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
$env:DATABASE_PASSWORD = "2503"
$env:DATABASE_HOST = "localhost" 
$env:SECRET_KEY_BASE = "xDqTau4dWLdp65pr3CC1vTDUh+YRZfYSCe43Uk6W6c0XBOC5MF2qpM70fQMGEF7L"
$env:PHX_PORT = "4000"
$env:REDIS_ENABLED = "false"
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

### Option 2: Local Development (With Redis Cache)

#### 1. Start Redis (Choose one option)

**Option A - Docker Redis:**
```bash
docker run -d -p 6379:6379 --name redis-cache redis:7-alpine
```

**Option B - Local Redis:**
```bash
redis-server
```

#### 2. Configure Environment Variables
```powershell
$env:DATABASE_PASSWORD = "2503"
$env:DATABASE_HOST = "localhost" 
$env:SECRET_KEY_BASE = "xDqTau4dWLdp65pr3CC1vTDUh+YRZfYSCe43Uk6W6c0XBOC5MF2qpM70fQMGEF7L"
$env:PHX_PORT = "4000"
$env:REDIS_ENABLED = "true"
$env:REDIS_URL = "redis://localhost:6379/0"
```

#### 3. Setup and Start
```bash
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
mix phx.server
```

### Option 3: Docker Deployment (Basic - No Cache)

#### 1. Update `.env` file:
```env
DATABASE_PASSWORD=2503
DATABASE_HOST=db
SECRET_KEY_BASE=xDqTau4dWLdp65pr3CC1vTDUh+YRZfYSCe43Uk6W6c0XBOC5MF2qpM70fQMGEF7L
PHX_PORT=4000
MIX_ENV=dev
REDIS_ENABLED=false
```

#### 2. Start with Docker Compose
```bash
docker-compose up --build
```

### Option 4: Docker Deployment (With Redis Cache) - **Recommended**

#### 1. Update `.env` file:
```env
DATABASE_PASSWORD=2503
DATABASE_HOST=db
SECRET_KEY_BASE=xDqTau4dWLdp65pr3CC1vTDUh+YRZfYSCe43Uk6W6c0XBOC5MF2qpM70fQMGEF7L
PHX_PORT=4000
MIX_ENV=dev
REDIS_ENABLED=true
REDIS_URL=redis://redis:6379/0
```

#### 2. Start with Redis Cache
```bash
docker-compose -f docker-compose.cache.yml up --build
```

This will:
- Start PostgreSQL database container
- Start Redis cache container
- Build and start Phoenix application container with cache enabled
- Automatically run migrations and seed data
- Make the application available at http://localhost:4000

## Performance Comparison

| Configuration | Authors Stats | Top Rated Books | Top Selling Books |
|---------------|---------------|-----------------|-------------------|
| **Without Cache** | ~470ms | ~70ms | ~40ms |
| **With Redis Cache** | ~20ms ⚡ | ~17ms ⚡ | ~20ms ⚡ |
| **Performance Gain** | **21x faster** | **4x faster** | **2x faster** |

## Application URLs

### Main Application
- **Homepage**: http://localhost:4000/
- **Analytics Dashboard**: http://localhost:4000/analytics

### CRUD Management
- **Authors**: http://localhost:4000/authors
- **Books**: http://localhost:4000/books
- **Reviews**: http://localhost:4000/reviews
- **Sales**: http://localhost:4000/sales

### Analytics Views (Cached)
- **Authors Statistics**: http://localhost:4000/analytics/authors_stats
- **Top 10 Rated Books**: http://localhost:4000/analytics/top_rated_books
- **Top 50 Selling Books**: http://localhost:4000/analytics/top_selling_books
- **Search Books**: http://localhost:4000/analytics/search

### Development Tools
- **LiveDashboard**: http://localhost:4000/dev/dashboard

## Environment Variables

### Database Configuration
```env
DATABASE_PASSWORD=2503                    # PostgreSQL password
DATABASE_HOST=localhost|db                # Database host (localhost for local, db for Docker)
SECRET_KEY_BASE=your_secret_key          # Phoenix secret key
PHX_PORT=4000                            # Application port
MIX_ENV=dev                              # Environment
```

### Redis Cache Configuration
```env
REDIS_ENABLED=true|false                 # Enable/disable Redis cache
REDIS_URL=redis://localhost:6379/0       # Redis connection URL
```

## Docker Commands

### Basic Deployment (No Cache)
```bash
# Start basic services
docker-compose up --build

# Start in background
docker-compose up --build -d

# Stop services
docker-compose down
```

### Redis Cache Deployment
```bash
# Start services with Redis cache
docker-compose -f docker-compose.cache.yml up --build

# Start in background
docker-compose -f docker-compose.cache.yml up --build -d

# View logs
docker-compose -f docker-compose.cache.yml logs web
docker-compose -f docker-compose.cache.yml logs redis

# Stop services
docker-compose -f docker-compose.cache.yml down

# Reset everything (removes volumes)
docker-compose -f docker-compose.cache.yml down -v
```

### Cache Management
```bash
# Check cached keys
docker exec phoenix_book_review-redis-1 redis-cli keys "*"

# Clear cache
docker exec phoenix_book_review-redis-1 redis-cli flushall

# Monitor Redis
docker exec -it phoenix_book_review-redis-1 redis-cli monitor
```

## Troubleshooting

### Local Development Issues
- **Database Connection**: Ensure PostgreSQL is running and DATABASE_PASSWORD is set
- **Cache Issues**: Verify Redis is running if REDIS_ENABLED=true
- **Permission Errors**: Remove `_build/` and `deps/` directories if they contain Docker files
- **Port 4000 in Use**: Change PHX_PORT environment variable

### Docker Issues
- **Build Errors**: Run `docker-compose build --no-cache`
- **Database Issues**: Check if containers are healthy with `docker-compose ps`
- **Redis Connection**: Verify Redis container is healthy and REDIS_URL is correct
- **Environment Variables**: Verify `.env` file has correct values

### Cache Issues
- **Cache Not Working**: Check `REDIS_ENABLED=true` and Redis is running
- **Slow Responses**: Verify cache keys exist with `redis-cli keys "*"`
- **Cache Invalidation**: Add/edit data to see cache refresh

## Architecture

### File Structure
```
phoenix_book_review/
├── lib/phoenix_book_review/
│   ├── catalog/                         # Business logic (split into contexts)
│   │   ├── author_context.ex           # Author operations with cache invalidation
│   │   ├── book_context.ex             # Book operations with cache invalidation  
│   │   ├── review_context.ex           # Review operations with cache invalidation
│   │   ├── sales_context.ex            # Sales operations with cache invalidation
│   │   ├── author_queries.ex           # Cached author analytics queries
│   │   ├── book_queries.ex             # Cached book analytics queries
│   │   └── queries.ex                  # Query delegation layer
│   └── services/                        # External services
│       ├── cache_service.ex            # Redis cache service with fallback
│       └── cache_invalidation.ex       # Smart cache invalidation
├── lib/phoenix_book_review_web/         # Web interface
├── priv/repo/migrations/                # Database migrations
├── priv/repo/seeds.exs                  # Mock data generation
├── docker-compose.yml                   # Basic Docker configuration
├── docker-compose.cache.yml            # Docker with Redis cache
└── .env                                # Environment variables
```

### Technology Stack

- **Backend**: Phoenix Framework (Elixir)
- **Database**: PostgreSQL
- **Cache**: Redis (with graceful fallback)
- **Frontend**: Phoenix HTML + TailwindCSS + DaisyUI
- **Deployment**: Docker + Docker Compose
- **Analytics**: Cached Ecto queries with aggregations
- **Performance**: Smart caching with TTL and invalidation

## Cache Implementation Details

- **Cache TTL**: 30 minutes for analytics, 10 minutes for search
- **Cache Keys**: Structured keys (e.g., `authors_stats_name_asc`, `top_rated_books_10`)
- **Cache Invalidation**: Automatic when data is modified
- **Graceful Degradation**: App works normally when Redis is unavailable
- **Performance**: 2-21x faster response times on cached queries
- **Environment Control**: Easy enable/disable via `REDIS_ENABLED` flag