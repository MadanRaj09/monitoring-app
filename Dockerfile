# Stage 1: Build the application
FROM python:3.9-slim AS builder

WORKDIR /app

# Copy only requirements files first to leverage Docker layer caching
COPY requirements.txt .

# Install application dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Stage 2: Create a minimal runtime image
FROM python:3.9-slim AS final

WORKDIR /app

# Copy the installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy the application code from the builder stage
COPY --from=builder /app .

# Expose the port the application will run on
EXPOSE 5000

# Set environment variables if needed
ENV FLASK_RUN_HOST=0.0.0.0

# Start the Flask application
CMD ["python", "app.py"]