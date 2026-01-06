# =========================
# Stage 1 - Builder
# =========================

# Use minimal base node image
FROM node:24-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only package files first (for better layer caching)
COPY package*.json ./

# Install production dependencies only
RUN npm ci --omit=dev

# Copy source code to working directory
COPY src ./src

# =========================
# Stage 2 - Runner
# =========================

FROM node:24-alpine
WORKDIR /app

# Copy files from builder
COPY --from=builder /app ./

# Switch to non-root user for improved container security (node user exists in base image)
RUN chown -R node:node /app
USER node

# Expose port
EXPOSE 8080

# Start application
CMD ["npm", "start"]
