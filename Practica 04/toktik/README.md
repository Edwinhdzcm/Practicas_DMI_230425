# Toktik - A Flutter Project

## Importante:
Los videos no están incluídos en el repositorio, debido a que son muy pesados y GitHub no lo permite.

Pueden descargar 8 videos de aquí:
[Pexels Free Videos](https://www.pexels.com/search/videos/vertical/)

Renombren esos videos así, ya que es lo que se encuentra en nuestro data source.
```
1.mp4
2.mp4
3.mp4
4.mp4
5.mp4
6.mp4
7.mp4
8.mp4
```


## Funcionalidades agregadas
Secciones Discover / For You / Favorites con desplazamiento lateral, temas por temporada,
mute, likes persistentes, descripcion con "... mas" y videos de YouTube, Dailymotion y Vimeo.
Arquitectura y diagramas: [docs/ARQUITECTURA.md](docs/ARQUITECTURA.md).

```
flutter pub get
flutter run
```

### Temas por temporada
Se eligen con la fecha del dispositivo. Cada temporada empieza 10 dias antes de su
celebracion: Halloween 21 oct-2 nov, Navidad 15 dic-6 ene, San Valentin (amor y amistad)
4-15 feb; Normal el resto del ano. Al cambiar la temporada se actualizan el icono del
launcher, el splash y el tema de la app. Para probar cualquiera sin esperar la fecha,
toca el icono de paleta arriba a la derecha; "Automatico" vuelve a la fecha. Cada tema
cambia tipografia, paleta, iconos y un jingle corto (audios originales).

> **Nota sobre `flutter run`:** al elegir una temporada distinta de Normal se
> desactiva el icono `.NormalIcon` del launcher, y `flutter run` siempre intenta
> abrir justo ese alias, por lo que fallaba con "Activity class does not exist".
> En builds de depuracion la app ahora mantiene `.NormalIcon` habilitado (por eso
> durante la temporada pueden verse dos iconos "toktik" en el launcher). En
> release solo queda el icono de la temporada activa.

Los videos de "For You" necesitan internet. El HLS de Dailymotion no se reproduce en web;
prueba en Android/iOS.

### Probar una temporada cambiando la fecha
La forma recomendada es tocar el icono de paleta y elegir la temporada: el splash, el tema
y el icono del launcher cambian al instante sin modificar el reloj.

Tambien puedes cambiar la fecha del emulador Android desde una terminal (requiere `adb`):

```powershell
adb root
adb shell settings put global auto_time 0
# Formato: MMDDhhmmAAAA.ss -> 21 de octubre de 2026, 15:00
adb shell date 102115002026.00
```

Reinicia la app (o desinstalala/instalala si el launcher no refresca el icono) para ver el
splash y el icono de Halloween. Para volver a la fecha automatica:

```powershell
adb shell settings put global auto_time 1
```

En un dispositivo fisico normalmente se necesita root; es mas facil cambiar la fecha en
Ajustes > Sistema > Fecha y hora.

### Audio de las temporadas (como cambiarlo)
Cada temporada tiene su jingle en `assets/audio/` y se reproduce al elegirla:

| Archivo          | Temporada            | Fechas             |
|------------------|----------------------|--------------------|
| `normal.wav`     | Normal               | resto del ano      |
| `halloween.wav`  | Halloween            | 21 oct - 2 nov     |
| `christmas.wav`  | Navidad              | 15 dic - 6 ene     |
| `valentine.wav`  | San Valentin         | 4 feb - 15 feb     |

Los cuatro jingles actuales son **originales**: los sintetiza
`tool/generate_season_audio.py` (Python puro, sin dependencias ni licencias de terceros).
Para regenerarlos o ajustar volumen/duracion:

```powershell
python tool/generate_season_audio.py
```

Si prefieres musica real, descarga una pista **libre de regalias** y guardala con el mismo
nombre (`normal.wav`, `halloween.wav`, `christmas.wav`, `valentine.wav`) y una duracion de
3-7 s. Sitios con musica libre:

- Pixabay Music: https://pixabay.com/music/ (Pixabay License, uso libre)
- Mixkit: https://mixkit.co/free-stock-music/ (Mixkit License, uso libre)
- Free Music Archive (filtro CC0): https://freemusicarchive.org/
- Incompetech (Kevin MacLeod, CC BY): https://incompetech.com/music/royalty-free/
- Freesound (filtro CC0): https://freesound.org/

Si usas CC BY, agrega el credito del autor en este README. Despues de reemplazar los
archivos hay que recompilar (`flutter run` / `flutter build`) porque los assets se
empaquetan en el APK. La copia de los audios anteriores quedo en `tool/audio_original/`.

### Demo en linea con Appetize.io
[Appetize.io](https://appetize.io) ejecuta el APK en un Android virtual dentro del
navegador y da un enlace publico para compartir (util para entregar la practica).

1. Crear una cuenta gratis en https://appetize.io/signup.
2. Compilar el APK de release:

```powershell
flutter build apk --release
# queda en build\app\outputs\flutter-apk\app-release.apk
```

3. Subirlo de cualquiera de estas dos formas:
   - Web: https://appetize.io/upload (arrastrar el `.apk`, plataforma Android).
   - Terminal (recomendado para re-subir cambios): generar un API token en
     **Account -> API Tokens** y ejecutar

```powershell
$env:APPETIZE_API_TOKEN = "tu_token"
.\tool\upload_to_appetize.ps1
```

El script imprime el enlace `https://appetize.io/app/<publicKey>`. Para actualizar la
misma app (sin crear otra) se le pasa el codigo: `-PublicKey <publicKey>`.

Notas:

- Plan Free: 30 minutos de streaming al mes, 2 dispositivos simultaneos y sesiones de
  3 minutos; alcanza para una demostracion corta.
- El audio del jingle se escucha activando el icono del altavoz del visor.
- El APK pesa ~82 MB. Los videos 5-8 (originalmente 4K y 266 MB) se recomprimieron a
  720p (~16 MB en total); la copia original quedo en `tool/video_original/`.
- La app necesita internet para YouTube/Dailymotion/Vimeo; el dispositivo de Appetize
  si tiene salida a internet.
