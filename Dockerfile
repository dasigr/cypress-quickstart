# Use official Node.js base image
FROM node:22.14.0

# Set working directory in container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose app port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
