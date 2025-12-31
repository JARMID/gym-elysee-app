# 🚀 Deployment Guide - GYM ÉLYSÉE DZ

This guide covers the deployment of the full stack:

1.  **Backend**: Laravel API
2.  **Frontend**: Flutter Web Application
3.  **Mobile**: Android/iOS Application

---

## 1. Backend Deployment (Laravel API)

The backend is built with Laravel 10.x. It serves as the data source for both the Web and Mobile apps.

### Prerequisites

- PHP 8.1 or higher
- Composer
- MySQL or PostgreSQL
- Nginx or Apache

### Installation Steps

1.  **Clone the Repository**

    ```bash
    git clone <backend-repo-url>
    cd gym-elysee-api
    ```

2.  **Install Dependencies**

    ```bash
    composer install --optimize-autoloader --no-dev
    ```

3.  **Environment Configuration**
    Copy the example environment file:

    ```bash
    cp .env.example .env
    ```

    **Critical Production Settings (`.env`):**

    ```ini
    APP_ENV=production
    APP_DEBUG=false
    APP_URL=https://api.yourdomain.com

    # Database
    DB_CONNECTION=mysql
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=gym_elysee_db
    DB_USERNAME=your_db_user
    DB_PASSWORD=your_db_password

    # CORS Configuration (CRITICAL for Web App)
    # Add your frontend domains here, comma-separated
    CORS_ALLOWED_ORIGINS=https://app.yourdomain.com,https://admin.yourdomain.com
    FRONTEND_URL=https://app.yourdomain.com
    ```

4.  **Generate Key & Migrations**
    ```bash
    php artisan key:generate
    php artisan migrate --force
    php artisan storage:link
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    ```

### Server Configuration (Nginx Example)

```nginx
server {
    listen 80;
    server_name api.yourdomain.com;
    root /var/www/gym-elysee-api/public;

    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }
}
```

---

## 2. Frontend Deployment (Flutter Web)

The web application (Admin & Member Portal) is built with Flutter Web.

### Build Steps

1.  **Configure API URL**
    Ensure your `lib/core/constants/api_constants.dart` or environment variables point to your **Production API URL** (`https://api.yourdomain.com`).

2.  **Build for Production**

    ```bash
    flutter build web --release --web-renderer html
    ```

    _Note: `--web-renderer html` is consistent across devices, but `auto` or `canvaskit` can be used for better performance._

3.  **Hosting**
    Upload the contents of `build/web/` to your web server (Nginx, Apache, Vercel, Netlify, Firebase Hosting).

### Handling Routing (SPA)

For Nginx, ensure all routes redirect to `index.html` so Flutter handles deep linking:

```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

---

## 3. Mobile Deployment (Android)

### Build Steps

1.  **Update Version**
    Update `version: 1.x.x+x` in `pubspec.yaml`.

2.  **Build APK**

    ```bash
    flutter build apk --release
    ```

    Output: `build/app/outputs/flutter-apk/app-release.apk`

3.  **Build App Bundle (Play Store)**
    ```bash
    flutter build appbundle --release
    ```
    Output: `build/app/outputs/bundle/release/app-release.aab`
