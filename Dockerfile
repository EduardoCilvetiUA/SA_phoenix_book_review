FROM elixir:1.18-alpine

# Install dependencies
RUN apk add --no-cache build-base npm git python3 curl inotify-tools

# Install Phoenix and Hex
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex phx_new --force

# Set work directory
WORKDIR /app

# Copy mix files
COPY mix.exs mix.lock ./

# Install mix dependencies
RUN mix deps.get

# Copy source code
COPY . .

# Install Node.js assets if package.json exists
RUN if [ -f "assets/package.json" ]; then \
        cd assets && npm ci --only=production && npm run deploy; \
    fi

# Compile assets and digest
RUN mix assets.deploy 2>/dev/null || echo "No assets to deploy"
RUN mix phx.digest

# Compile the application
RUN MIX_ENV=dev mix compile

# Expose Phoenix port
EXPOSE 4000

# Start the Phoenix server
CMD ["mix", "phx.server"]