# Use an official Python base image
FROM python:3.10-slim

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FLASK_ENV=production \
    FLASK_APP=run.py

# Set working directory inside the container
WORKDIR /app

# Copy only requirement files first to leverage Docker cache
COPY requirements.txt .

# Install system-level dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the whole project into the container
COPY . .

# Expose port to access Flask via Gunicorn
EXPOSE 8000

# Run the Gunicorn production server
CMD ["gunicorn", "--config", "gunicorn.conf.py", "run:app"]
