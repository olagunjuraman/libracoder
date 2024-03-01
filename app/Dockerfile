# Stage 1: Build and Dependencies Installation
FROM node:16 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Stage 2: Runtime Setup
FROM node:16-alpine

WORKDIR /app

COPY --from=builder /app ./

RUN npm ci --only=production

# Copy the entry-point script and make it executable
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3000

# Use the entry-point script to start the container
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
