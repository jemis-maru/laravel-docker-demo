# Laravel Docker Demo

A Laravel application configured to run with Docker using PHP-FPM and Nginx.

## 🐳 Docker Configuration

This project includes the following Docker configuration files:

- **Dockerfile** - PHP-FPM 8.2 container with Laravel dependencies
- **docker-compose.yml** - Orchestrates PHP-FPM and Nginx services
- **nginx.conf** - Nginx server configuration for Laravel
- **.dockerignore** - Excludes unnecessary files from Docker build

## 📋 Prerequisites

Before you begin, ensure you have the following installed on your system:

- Ubuntu/Debian-based Linux distribution
- sudo privileges

## 🚀 Installation

### Step 1: Install Docker

Run the following commands to install Docker and Docker Compose:

```bash
# Update package index
sudo apt-get update

# Install required packages
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again
sudo apt-get update

# Install Docker Engine and Docker Compose
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Step 2: Build and Start Docker Containers

Navigate to the project directory and run:

```bash
cd /home/bacancy/Jemis/Projects/laravel/docker-demo

# Build and start containers in detached mode
docker compose up -d --build
```

### Step 3: Install Laravel Dependencies

```bash
# Install Composer dependencies
docker compose exec php composer install

# Generate application key
docker compose exec php php artisan key:generate
```

### Step 4: Set Permissions

```bash
# Set proper permissions for Laravel directories
sudo docker compose exec php chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
```

### Step 5: Access the Application

Open your browser and navigate to:

```
http://localhost:8080
```

## 🏗️ Architecture

### Services

- **PHP-FPM (php)** - Runs on port 9000, processes PHP requests
- **Nginx (nginx)** - Runs on port 8080, serves static files and proxies PHP requests to PHP-FPM

### Network

All services communicate through a custom bridge network called `laravel-network`.

## 🛠️ Common Docker Commands

### Start containers
```bash
docker compose up -d
```

### Stop containers
```bash
docker compose down
```

### View logs
```bash
# All services
docker compose logs

# Specific service
docker compose logs php
docker compose logs nginx
```

### Execute commands in PHP container
```bash
docker compose exec php php artisan migrate
docker compose exec php php artisan cache:clear
docker compose exec php composer update
```

### Rebuild containers
```bash
docker compose up -d --build
```

### View running containers
```bash
docker compose ps
```

## 📁 Project Structure

```
.
├── Dockerfile              # PHP-FPM container configuration
├── docker-compose.yml      # Docker Compose orchestration
├── nginx.conf              # Nginx server configuration
├── .dockerignore           # Files to exclude from Docker build
├── app/                    # Laravel application code
├── config/                 # Laravel configuration files
├── public/                 # Public assets (entry point)
├── storage/                # Application storage
└── vendor/                 # Composer dependencies
```

## 🔧 Configuration Details

### PHP Extensions Installed
- pdo_mysql
- mbstring
- exif
- pcntl
- bcmath
- gd

### Ports
- **8080** - Nginx (HTTP)
- **9000** - PHP-FPM (internal)

## 🐛 Troubleshooting

### Permission Issues
If you encounter permission errors, run:
```bash
sudo docker compose exec php chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
sudo docker compose exec php chmod -R 755 /var/www/html/storage
sudo docker compose exec php chmod -R 755 /var/www/html/bootstrap/cache
```

### Container Not Starting
Check logs for errors:
```bash
docker compose logs php
docker compose logs nginx
```

### Clear Application Cache
```bash
docker compose exec php php artisan cache:clear
docker compose exec php php artisan config:clear
docker compose exec php php artisan route:clear
docker compose exec php php artisan view:clear
```

## 📝 License

This is a demo project for Laravel with Docker configuration.

## 👨‍💻 Development

For development, the project directory is mounted as a volume, so any changes you make will be reflected immediately without rebuilding the containers.
