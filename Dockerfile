# Build stage
FROM node:18-alpine AS builder
WORKDIR /src/app  # Assuming your app is in the src/app folder in the repo

# Copy package.json and package-lock.json to the build container
COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production

# Copy the rest of your application files to the build container
COPY . .

# Run tests (optional, can be skipped if you don't need it for the build process)
RUN npm run test

# Runtime stage
FROM node:18-alpine

# Set the working directory for the runtime container
WORKDIR /app

# Copy node_modules and app code from the build container
COPY --from=builder /src/app/node_modules ./node_modules
COPY --from=builder /src/app/src ./src

# Expose the port your app will listen on
EXPOSE 8080

# Switch to a non-root user
USER node

# Start the application
CMD ["node", "src/app.js"]
