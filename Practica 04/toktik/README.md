# toktik

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## TokTik: APIs y almacenamiento local

La app mezcla videos de `assets/videos/` con YouTube, Instagram y Facebook.
Las llaves se pasan con `--dart-define` (no se guardan en el código):

```bash
flutter pub get
flutter run \
  --dart-define=YOUTUBE_API_KEY=xxxx \
  --dart-define=INSTAGRAM_ACCESS_TOKEN=xxxx \
  --dart-define=INSTAGRAM_USER_ID=xxxx \
  --dart-define=FACEBOOK_ACCESS_TOKEN=xxxx \
  --dart-define=FACEBOOK_PAGE_ID=xxxx
```

Si falta alguna llave, esa fuente se omite y la app sigue con las demás.
Con `shared_preferences` se guardan el feed (caché), los likes y el estado de mute.

Alternativa más cómoda: copia `env.example.json` a `env.json`, llena tus llaves y corre:

```bash
flutter run --dart-define-from-file=env.json
```

`env.json` está en el `.gitignore`, así que no se sube al repositorio.
