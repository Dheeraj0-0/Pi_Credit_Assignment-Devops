# --- STAGE 1: The Builder ---
# This stage installs dependencies and prepares the app
FROM node:18-alpine AS builder
WORKDIR /app

# Copy package files and install dependencies
COPY app/package*.json ./
RUN npm install

# Copy the rest of the application source code
COPY app/ ./

# --- STAGE 2: The Final Image ---
# This stage creates the lean, final container
FROM node:18-alpine
WORKDIR /app

# Copy only the necessary files from the 'builder' stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/src ./src

# Expose the port the app runs on
EXPOSE 3000

# The command to start the application
CMD ["node", "src/index.js"]
