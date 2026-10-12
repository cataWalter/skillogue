# Skillogue — Connect Through Passions

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-2.18+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Hive](https://img.shields.io/badge/Local_Store-Hive-FFC107)](https://pub.dev/packages/hive)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](#)

> A cross-platform social app that connects people through **shared passions** — not profile pictures.
>
> ⚠️ **Note:** this is the original **Flutter mobile client** of Skillogue. The project later evolved into a full-stack web platform: see [skillogue-web](https://github.com/cataWalter/skillogue-web). This repository is preserved as the mobile reference implementation.

---

## ✨ Overview

Skillogue is a passion-based social network. Instead of swiping on photos, users build a profile from their **interests, languages and location**, and discover people who genuinely share their world. Profile pictures are **randomly generated** and cannot be uploaded, so first impressions are driven by personality and shared interests.

### Core features

- **Guided registration** — a step-by-step onboarding flow.
- **Passion-based profiles** — a large curated taxonomy of skills/interests.
- **Advanced search & filters** — find people by passion, language, country, age and gender.
- **Saved searches** — store and re-run frequent queries.
- **1-to-1 messaging** — private conversations between matched users.
- **Random avatars** — identity decoupled from appearance.
- **Multi-language UI** — built-in localization framework.
- **Push notifications** — via OneSignal + Firebase Cloud Messaging.
- **Theming** — light/dark support with a custom theme manager.

---

## 🏗️ Architecture

The codebase follows a clean **layer separation** to keep UI, domain and data concerns decoupled:

```
lib/
├── screens/          # UI layer (feature-first)
│   ├── authorization/  # splash, sign-in/up, guided registration
│   ├── home/
│   ├── profile/        # overview + settings
│   ├── search/         # profile search, results, saved searches
│   └── messages/       # conversation list + single conversation
├── entities/         # Domain models (Profile, Message, Conversation, ProfileSearch)
├── utils/
│   ├── backend/        # Data layer: auth, profile, search, messages, misc
│   ├── widgets/        # Reusable UI components
│   └── ...             # constants, colors, localization, responsive layout
└── main.dart         # App entry point & bootstrap
```

- **Data layer (`utils/backend/`)** wraps all Supabase calls behind small, focused modules — swapping the backend (e.g. REST) would not touch the UI.
- **Local cache** via **Hive** for offline resilience and fast startup.
- **Remote state** via **Supabase** (Postgres + Auth).

---

## 🧰 Tech stack

| Concern | Choice |
|---|---|
| UI framework | Flutter (Material) |
| Language | Dart |
| Backend / Auth | Supabase (Postgres, GoTrue) |
| Local storage | Hive / hive_flutter |
| Push notifications | OneSignal + Firebase Messaging |
| Localization | flutter_localization |
| Fonts | google_fonts |
| Charts/pickers | flex_color_picker, multi_select_flutter, cupertino_range_slider |

---

## 🚀 Getting started

```bash
# 1. Prerequisites: Flutter SDK (3.x) and a Supabase project
git clone https://github.com/cataWalter/skillogue.git
cd skillogue

# 2. Install dependencies
flutter pub get

# 3. Configure your Supabase credentials (see lib/utils/constants.dart)
#    and any push-notification keys before running.

# 4. Run on a connected device/emulator
flutter run
```

---

## 📸 Screenshots

> _TODO: add screenshots of onboarding, search filters, and the conversation screen._

---

## 📄 License

Released for portfolio/educational purposes. See the repository for details.
