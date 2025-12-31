# 🚀 DÉMARRAGE RAPIDE - GYM ÉLYSÉE DZ

Guide simple pour démarrer le projet en LOCAL.

---

## 📱 FRONTEND FLUTTER

### 1. Installer les dépendances
```bash
cd gyelyseedz
flutter pub get
```

### 2. Générer les fichiers de code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configurer l'API (si backend local)
Le fichier `lib/core/constants/api_constants.dart` est déjà configuré pour `localhost:8000`.

**Pour Android Emulator** : Changez vers `http://10.0.2.2:8000/api`
**Pour iOS Simulator** : Gardez `http://localhost:8000/api`
**Pour appareil physique** : Utilisez l'IP de votre ordinateur (ex: `http://192.168.1.100:8000/api`)

### 4. Lancer l'app
```bash
flutter run
```

---

## 🏗️ BACKEND LARAVEL (Simple Local)

### 1. Créer le projet
```bash
composer create-project laravel/laravel gym-elysee-api
cd gym-elysee-api
```

### 2. Installer les packages
```bash
composer require laravel/sanctum
composer require spatie/laravel-permission
composer require spatie/laravel-media-library
composer require intervention/image
```

### 3. Configurer SQLite
```bash
# Créer le fichier de base de données
touch database/database.sqlite
```

### 4. Configurer .env
```env
DB_CONNECTION=sqlite
DB_DATABASE=/chemin/absolu/vers/gym-elysee-api/database/database.sqlite

SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1

FILESYSTEM_DISK=local
```

### 5. Publier les configurations
```bash
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
php artisan vendor:publish --provider="Spatie\Permission\PermissionServiceProvider"
php artisan vendor:publish --provider="Spatie\MediaLibrary\MediaLibraryServiceProvider"
```

### 6. Générer la clé
```bash
php artisan key:generate
```

### 7. Créer les migrations
Utilisez le prompt `PROMPT_BACKEND_LARAVEL_SIMPLE.md` pour créer les migrations.

### 8. Migrer
```bash
php artisan migrate
```

### 9. Lancer le serveur
```bash
php artisan serve
```

Le serveur sera disponible sur `http://localhost:8000`

---

## 🔗 CONNEXION FLUTTER ↔ LARAVEL

### Vérifier la connexion

1. **Backend Laravel** : `http://localhost:8000` doit répondre
2. **Flutter** : L'app doit pointer vers `http://localhost:8000/api`

### Tester l'API

```bash
# Test simple
curl http://localhost:8000/api/branches
```

### Problèmes courants

**Android Emulator ne peut pas accéder à localhost :**
- Changez `api_constants.dart` vers `http://10.0.2.2:8000/api`

**CORS Error :**
- Ajoutez dans `config/cors.php` :
```php
'paths' => ['api/*'],
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
```

---

## ✅ CHECKLIST

- [ ] Flutter : `flutter pub get` ✅
- [ ] Flutter : `build_runner` ✅
- [ ] Laravel : Projet créé ✅
- [ ] Laravel : Packages installés ✅
- [ ] Laravel : SQLite configuré ✅
- [ ] Laravel : Migrations créées ✅
- [ ] Laravel : `php artisan serve` ✅
- [ ] Flutter : API URL configurée ✅
- [ ] Test connexion ✅

---

**C'est tout ! Simple et local. 🎉**

