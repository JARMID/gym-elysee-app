# Gym Élysée - Admin & Coach Guide

## Overview

This guide lists the administrative capabilities of the Gym Élysée website and mobile app ecosystem.

## 1. User Authentication

### Registration & Login

- **Users**: Can register via the Mobile App or Web Portal (`/register`).
- **Coaches**: Currently managed via the backend database.
- **Admins**: Login via the Laravel Admin Panel.

### Credentials

- **Default Admin**: `admin@gymelysee.dz` / `password` (if seeded)
- **Test User**: `user@test.com` / `password`

## 2. Managing Content

### Branches (Clubs)

Branch data is currently stored in the database but seeded from code.

- **Source**: `database/seeders/BranchSeeder.php`
- **To Update**:
  1. Edit the `BranchSeeder.php` file.
  2. Run `php artisan db:seed --class=BranchSeeder` on the server.
- **Images**: Branch images are stored in `assets/images/branches/` or external URLs.

### Blog Posts

Blog posts are currently hardcoded in `lib/core/constants/blog_data.dart` or `WebBlogPage`.

- **To Add Post**: Add a new `BlogPost` object to the list in `blog_data.dart`.
- **Images**: Use unsplash URLs or add assets to `assets/images/blog/`.

### Membership Plans

Plans are managed in `LandingRepository` or database.

- **Source**: `gym-elysee-api/app/Repositories/LandingRepository.php`
- **Update**: Edit the return array in `getMembershipPlans()`.

## 3. Coach Management

Coaches are retrieved via the API.

- **Endpoint**: `GET /api/coaches`
- **Database Table**: `coaches`
- **To Add Coach**:
  - Insert into `users` table with role `coach`.
  - Or use the Laravel Nova/Filament admin panel if installed.

## 4. Troubleshooting

### "Missing Images"

- Ensure images exist in `assets/images/`.
- If using Network Images, ensure the domain is whitelisted in `macos/Runner/DebugProfile.entitlements` (for iOS/Mac) and `AndroidManifest.xml` (Android).
- For Web, CORS issues may arise with some image providers.

### "API Connection Error"

- Web: Ensure `localhost` or the specific IP is accessible.
- Flutter Web: Run with `--web-renderer html` if images fail to load due to CORS.

## 5. Deployment

### Flutter Web

1. Build: `flutter build web --release`
2. Deploy `build/web` folder to hosting (Vercel, Netlify, Apache).

### Laravel API

1. Ensure `.env` is configured (DB_HOST, DB_PASS).
2. Run migrations: `php artisan migrate`.
3. Seed data: `php artisan db:seed`.
