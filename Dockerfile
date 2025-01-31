# Build stage
FROM node:18-alpine AS builder
WORKDIR /app

# Copy package files first
COPY ./src/app/package*.json ./

# Install dependencies
RUN npm ci --verbose

# Copy application files
COPY ./src/app/ ./  # ✅ Ensure this path is correct

# Run tests (pass even if no tests exist)
RUN npm run test -- --passWithNoTests

# Remove dev dependencies after tests
RUN npm prune --production

# Runtime stage
FROM node:18-alpine
WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app ./  # ✅ Fix copy path

EXPOSE 8080
USER node
CMD ["node", "app.js"]
