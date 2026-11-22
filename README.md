# Islamic Shikkha (Flutter starter)

Bangla-first, offline-first Islamic learning app starter.

## Important content-safety note
This starter intentionally contains clearly labelled placeholder content. It does **not** include invented Quran verses, hadith, dua wording, prayer rulings, or recitation audio. Replace TODO entries only after checking source permissions and having the material reviewed by a qualified scholar.

## Create the Flutter platform project
```bash
flutter create --org com.example islamic_shikkha
# Copy this starter's pubspec.yaml, lib/, assets/, CREDITS.md and schemas/ into the generated project.
flutter pub get
flutter run
```

This repository is a source scaffold, not a precompiled APK. It has not been built against a local Flutter SDK in this environment.

## Offline policy
- Bundled JSON, fonts, images and audio provide learning content.
- No backend, login, Firebase, or content API is included.
- AdMob and Google Play Billing are optional network-dependent integrations; failures must not block core features.
- Prayer times are calculated on-device.

## First implementation target
Complete Noorani Qaida first: validate lesson content, record qari audio, implement tap-to-play, progress persistence, and a lesson quiz.
