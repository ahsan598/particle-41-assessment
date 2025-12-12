# =========================
# Stage 1 - Builder
# =========================

# Use minimal base node image
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only package files first (for better layer caching)
COPY package*.json ./

# Install production dependencies only
RUN npm install --production

# Copy source code to working directory
COPY . .

# =========================
# Stage 2 - Runner
# =========================

FROM node:20-alpine
WORKDIR /app

# Copy files from builder
COPY --from=builder /app ./

# Expose port
EXPOSE 8080

# Run as non-root user (node user exists in alpine)
USER node

# Start application
CMD ["npm", "start"]