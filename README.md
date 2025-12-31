# 🏋️ GYM ÉLYSÉE DZ

Application mobile Flutter pour la chaîne de salles de sport premium algérienne **GYM ÉLYSÉE DZ**.

## 📱 À propos

**GYM ÉLYSÉE DZ** est une application mobile complète permettant aux membres de gérer leur abonnement, réserver des cours, suivre leurs programmes d'entraînement, et bien plus encore.

### 🎯 Carte Membre Universelle

Chaque membre reçoit une **carte membre digitale** avec un QR code unique qui fonctionne pour **toutes les branches** de GYM ÉLYSÉE DZ. Cette carte permet :

- ✅ Accès rapide à toutes les branches (6 branches)
- ✅ Check-in instantané via scan QR
- ✅ Vérification automatique de l'abonnement
- ✅ Suivi de la présence dans toutes les branches

### Fonctionnalités Principales

#### Pour les Membres

- ✅ **QR Code Check-In** : Accès rapide aux salles avec QR code personnel
- ✅ **Dashboard Personnalisé** : Statistiques, prochaines sessions, feed social
- ✅ **Programmes d'Entraînement** : Bibliothèque complète avec vidéos et instructions
- ✅ **Workout Player** : Lecteur vidéo avec timer de repos et suivi des performances
- ✅ **Système de Réservation** : Réserver cours collectifs, sessions privées, sparring
- ✅ **Stats Combat** : Suivi des performances pour boxeurs et pratiquants de MMA
- ✅ **Métriques Corporelles** : Suivi poids, masse musculaire, photos de progression
- ✅ **Feed Social** : Communauté, transformations, motivation
- ✅ **Trouver un Partenaire de Sparring** : Matchmaking par discipline et niveau
- ✅ **Messagerie** : Chat avec les coaches
- ✅ **Gestion d'Abonnement** : Renouvellement, historique, paiements échelonnés
- ✅ **Mode Ramadan** : Horaires adaptés, plans spéciaux, recettes

#### Pour les Coaches

- ✅ Dashboard coach avec planning et revenus
- ✅ Gestion de la squad d'élèves
- ✅ Créateur de programmes d'entraînement
- ✅ Validation de présence via QR code

#### Pour les Admins

- ✅ Analytics dashboard complet
- ✅ Gestion membres, coaches, branches
- ✅ Validation des paiements
- ✅ Modération du contenu

## 🏗️ Architecture

### Structure du Projet

```
lib/
├── core/                    # Fonctionnalités de base
│   ├── constants/          # Constantes API, app, storage
│   ├── theme/              # Thèmes (Dark + Ramadan)
│   ├── utils/              # Validators, formatters, extensions
│   └── errors/             # Exceptions et failures
│
├── data/                    # Couche de données
│   ├── models/             # Modèles de données
│   ├── repositories/       # Repositories pour API
│   └── services/           # Services (API, Storage, Notifications)
│
└── presentation/            # Interface utilisateur
    ├── providers/          # Riverpod providers
    ├── screens/            # Écrans de l'application
    └── widgets/            # Widgets réutilisables
```

### Technologies Utilisées

- **Flutter** : Framework de développement mobile
- **Riverpod** : Gestion d'état
- **Dio** : Client HTTP pour les appels API
- **Go Router** : Navigation
- **Hive** : Base de données locale
- **Flutter Secure Storage** : Stockage sécurisé des tokens

## 🚀 Installation

### Prérequis

- Flutter SDK 3.10.1 ou supérieur
- Dart SDK 3.10.1 ou supérieur
- Android Studio / Xcode (pour développement mobile)

### Étapes d'Installation

1. **Cloner le repository**

   ```bash
   git clone <repository-url>
   cd gyelyseedz
   ```

2. **Installer les dépendances**

   ```bash
   flutter pub get
   ```

3. **Générer les fichiers de code**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configurer l'API Backend**

   Modifiez `lib/core/constants/api_constants.dart` pour pointer vers votre backend :

   ```dart
   static const String baseUrl = 'http://your-backend-url.com/api';
   ```

5. **Lancer l'application**
   ```bash
   flutter run
   ```

## 🔧 Configuration & Deployment

### Backend & Web Deployment

👉 **[Read the Deployment Guide](DEPLOYMENT.md)** for full instructions on hosting the API and Web App.

### Variables d'Environnement

L'application supporte la configuration via `.env` pour le backend et des constantes compilées pour le frontend.

## 📱 Fonctionnalités Détaillées

### QR Code Check-In

Les membres peuvent scanner leur QR code à l'entrée de la salle pour un accès rapide.

### Programmes d'Entraînement

- Bibliothèque complète de programmes créés par les coaches
- Filtrage par niveau, discipline, branche
- Vidéos d'exercices avec instructions en Darja

### Mode Ramadan

Activation d'un thème spécial Ramadan avec horaires adaptés et interface or/violet.

## 🌐 Branches Supportées

1. **🏛️ GYM ÉLYSÉE DZ** (Flagship - Hydra)
2. **🥊 GYM ÉLYSÉE BOXE** (Oran)
3. **🐯 TIGER SPORT DZ** (Constantine)
4. **🤼 GYM ÉLYSÉE GRAPPLING** (Annaba)

## 💳 Paiements

Support complet pour **eDahabia**, **CIB**, et **Baridimob**.

## ✅ Status du Projet

- [x] **Dashboard Membre**: Statistiques, Prochains cours, QR Code
- [x] **Programmes**: Bibliothèque, Détails, Vidéo Player
- [x] **Réservation**: Cours, Sessions Privées
- [x] **Dashboard Coach**: Gestion élèves, Planning
- [x] **Dashboard Admin**: Analytics, Gestion Membres/Coaches, Paiements
- [x] **Social**: Messagerie Coach-Élève
- [x] **Paiements**: Intégration CIB/Edahabia (Simulation)
- [x] **Support Multi-langue**: Français, Arabe, Anglais
- [x] **Thèmes**: Light, Dark, System

## 📚 Documentation

- [Guide de Déploiement](DEPLOYMENT.md)
- [Architecture](docs/DIAGRAMS.md)

## 🤝 Contribution

Ce projet est un projet scolaire. Pour contribuer :

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est développé dans le cadre d'un projet scolaire.

## 👥 Équipe

Développé avec ❤️ pour GYM ÉLYSÉE DZ

---

**Note** : Cette application nécessite un backend Laravel fonctionnel. Assurez-vous de suivre le guide de configuration backend avant de lancer l'application.
