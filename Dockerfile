# Build stage
FROM node:18-alpine AS builder
WORKDIR /src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Debug: List the files in the working directory before installing
RUN ls -la /src/app

# Install production dependencies and show verbose output for troubleshooting
RUN npm ci --only=production --verbose

# Copy the rest of your application files to the build container
COPY . .

# Debug: List files after copying
RUN ls -la /src/app

# Run tests (optional, can be skipped if you don't need it for the build process)
RUN npm run test

# Runtime stage
FROM node:18-alpine

WORKDIR /app
COPY --from=builder /src/app/node_modules ./node_modules
COPY --from=builder /src/app/src ./src

EXPOSE 8080
USER node
CMD ["node", "src/app.js"]
