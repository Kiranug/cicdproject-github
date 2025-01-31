# Build stage
FROM node:18-alpine AS builder
WORKDIR /app

# Copy package.json and package-lock.json
COPY src/app/package*.json ./

# Install all dependencies (including dev dependencies for testing)
RUN npm ci --verbose

# Copy the rest of the application files
COPY src/app/ ./

# Run tests (allow build to pass even if no tests exist)
RUN npm run test -- --passWithNoTests

# Remove dev dependencies after tests to reduce image size
RUN npm prune --production

# Runtime stage
FROM node:18-alpine
WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src

EXPOSE 8080
USER node
CMD ["node", "src/app.js"]
