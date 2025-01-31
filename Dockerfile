# Build stage
FROM node AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run test

# Runtime stage
FROM node
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src
EXPOSE 8080
USER node
CMD ["node", "src/app.js"]
