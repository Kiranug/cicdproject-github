# Build stage
FROM node:18-alpine AS builder
WORKDIR /app

# Copy package.json and package-lock.json from /src/app/ to /app/ in the container
COPY src/app/package*.json ./

# Debugging step: List files to check if package-lock.json is copied
RUN ls -la /app

# Install production dependencies
RUN npm ci --only=production --verbose

# Copy the rest of the application files
COPY src/app/ ./

# Run tests
RUN npm run test

# Runtime stage
FROM node:18-alpine
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src

EXPOSE 8080
USER node
CMD ["node", "src/app.js"]
