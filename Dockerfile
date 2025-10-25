# ==============================================================================
# Dockerfile - Builds the PHP-FPM container for Laravel application
# ==============================================================================
# This file defines how to build a Docker image that contains PHP-FPM (FastCGI
# Process Manager) which processes PHP code for our Laravel application.
# It installs all necessary dependencies, PHP extensions, and Composer.
# ==============================================================================

# Use official PHP-FPM image as the base
# PHP 8.2 with FPM (FastCGI Process Manager) - handles PHP processing
# FPM is more efficient than mod_php for handling multiple requests
FROM php:8.2-fpm

# Set the working directory inside the container
# All subsequent commands will run from this directory
# /var/www/html is the standard web server directory in Linux
WORKDIR /var/www/html

# Install system-level dependencies required by Laravel and PHP extensions
# RUN executes commands during the image build process
RUN apt-get update && apt-get install -y \
    git \                    # Version control - needed for Composer dependencies
    curl \                   # Command-line tool for transferring data
    libpng-dev \            # PNG image library - required for GD extension
    libonig-dev \           # Oniguruma library - required for mbstring extension
    libxml2-dev \           # XML library - required for XML operations
    zip \                    # Compression utility - needed for Composer
    unzip \                  # Decompression utility - needed for Composer packages
    && apt-get clean && rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# Install PHP extensions that Laravel requires
# docker-php-ext-install is a helper script provided by the official PHP image
RUN docker-php-ext-install \
    pdo_mysql \             # PDO driver for MySQL - database connectivity
    mbstring \              # Multibyte string handling - for international characters
    exif \                  # Extract EXIF data from images
    pcntl \                 # Process control - for queue workers and async tasks
    bcmath \                # Arbitrary precision mathematics - for financial calculations
    gd                      # Image processing library - for image manipulation

# Install Composer (PHP dependency manager)
# COPY --from allows us to copy files from another image without building it
# This is a multi-stage build technique to get Composer binary
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the entire Laravel application from host machine to container
# . means current directory on host (where Dockerfile is)
# /var/www/html is the destination inside container
# Note: .dockerignore file controls which files are excluded from this copy
COPY . /var/www/html

# Set proper ownership and permissions for Laravel directories
# www-data is the default user that Nginx/Apache uses to run web applications
# This ensures the web server can read/write to necessary directories
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \          # Storage directory - logs, cache, uploads
    && chmod -R 755 /var/www/html/bootstrap/cache    # Bootstrap cache - compiled services

# Expose port 9000 to allow external connections
# PHP-FPM listens on port 9000 by default
# This port is used internally by Nginx to communicate with PHP-FPM
EXPOSE 9000

# Define the default command to run when container starts
# Starts the PHP-FPM service in foreground mode
# This keeps the container running and processes PHP requests
CMD ["php-fpm"]
