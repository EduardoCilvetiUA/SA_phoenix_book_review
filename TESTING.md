# Testing Guide - Assignment 3 (Redis Cache + Elasticsearch Search)

## Quick Setup

### 🎯 **Simple Approach**: Pick what you want to test

```bash
# Test EVERYTHING (Cache + Search)
docker-compose -f docker-compose.full.yml up -d

# Test CACHE only (Redis + DB + App)  
docker-compose -f docker-compose.cache.yml up -d

# Test SEARCH only (Elasticsearch + DB + App)
docker-compose -f docker-compose.search.yml up -d

# Test BASIC app only (DB + App)
docker-compose up -d
```

### 🔧 **Answer to your question about .env:**

**You're absolutely right!** The current setup is confusing:

- `docker-compose.full.yml` starts ALL services
- But `.env` flags control if the **app uses them**
- Result: Services run but might be ignored = **Resource waste!**

### ✅ **Recommendation**: 

**Keep it simple - use the right compose file for what you want to test:**

1. **Testing both features?** → Use `docker-compose.full.yml` + set both flags to `true` in .env
2. **Testing just cache?** → Use `docker-compose.cache.yml` + set `REDIS_ENABLED=true`
3. **Testing just search?** → Use `docker-compose.search.yml` + set `ELASTICSEARCH_ENABLED=true`

**This way:**
- ✅ Only needed services start
- ✅ No resource waste  
- ✅ .env flags match what's running

## Testing Features

### 🚀 Cache Performance Testing (Redis)

1. **Go to Analytics**: http://localhost:4000/analytics/authors_stats
   - First load: Slower (database query)
   - Refresh page: Much faster (Redis cache)
   - Look for "Done in XXXms" at bottom

2. **Compare Performance**:
   ```bash
   # Test without cache (disable Redis in .env)
   REDIS_ENABLED=false
   
   # Test with cache  
   REDIS_ENABLED=true
   ```

### 🔍 Search Testing (Elasticsearch)

1. **Go to Search**: http://localhost:4000/analytics/search

2. **Try These Searches**:
   - `phoenix` - Should find books with Phoenix in title/summary
   - `epic` - Finds books with "epic journey" summaries  
   - `journey` - Full-text search in summaries
   - `king` - Searches both author names and book content

3. **Test Fallback**: 
   - Set `ELASTICSEARCH_ENABLED=false` in .env
   - Restart: Search still works (uses database)
   - Set `ELASTICSEARCH_ENABLED=true`: Faster search via Elasticsearch

## Expected Results

### Cache Performance (Redis)
- **Without Redis**: Authors stats ~50-200ms
- **With Redis**: Authors stats ~5-20ms (2-10x faster)
- Cache auto-invalidates when data changes

### Search Performance (Elasticsearch)  
- **Database Search**: Simple LIKE queries, slower
- **Elasticsearch**: Full-text search with relevance scoring
- **Graceful Fallback**: Works even if Elasticsearch is down

### Multi-Service Stack
- **All services working together**
- **Independent failure handling**
- **Environment-controlled features**

## Troubleshooting

### If containers won't start:
```bash
# Clean up
docker-compose down
docker system prune -f

# Try again
docker-compose -f docker-compose.full.yml up -d
```

### If indexing takes too long:
- Wait 2-3 minutes for initial indexing to complete
- Check logs: `docker-compose logs web`
- Look for "Books indexing completed"

### If search doesn't work:
- Check Elasticsearch is healthy: `docker-compose ps`
- Verify ELASTICSEARCH_ENABLED=true in .env
- Check logs for errors: `docker-compose logs web`

### ✅ FIXED: KeyError in search results
- **Issue**: Sometimes got "key :book not found" errors
- **Cause**: Cache storing results in wrong format
- **Fix**: Fixed Elasticsearch response format + cleared cache conflicts
- **Status**: Now working properly with search caching enabled (5 min TTL)

## Quick Tests

### Test Cache Hit/Miss:
1. Visit: http://localhost:4000/analytics/top_selling_books
2. Check page load time at bottom
3. Refresh - should be much faster

### Test Search:  
1. Visit: http://localhost:4000/analytics/search
2. Search for: "compelling narrative"
3. Should find multiple books with that phrase

### Test Both Together:
1. Use docker-compose.full.yml  
2. Test analytics (cache) + search (elasticsearch)
3. Both should be fast and working simultaneously