# Práctica 04 — TokTik

Aplicación móvil desarrollada con **Flutter** como práctica de Desarrollo Móvil Integral.
TokTik presenta videos en formato vertical y permite explorar contenido local y videos
obtenidos de servicios en línea. La aplicación utiliza **Provider** para administrar el
estado y adapta su apariencia a distintas temporadas del año.

> **Importante:** los videos locales no están incluidos en el repositorio por su tamaño.
> Para ver el contenido de **Discover**, coloca los archivos indicados en
> [`assets/videos/`](assets/videos/). La sección **For You** requiere conexión a internet.

## Evidencias de la práctica

Agrega los enlaces de tus videos de demostración cuando estén disponibles. Puedes subirlos
a YouTube, Google Drive u otro servicio y pegar aquí el enlace con permisos de visualización.

| Evidencia | Enlace |
| --- | --- |
| Video de presentación y recorrido general | **PENDIENTE: pega aquí el enlace del video** |
| Video de las secciones y reproducción de contenido | **PENDIENTE: pega aquí el enlace del video** |
| Video de los temas por temporada y persistencia | **PENDIENTE: pega aquí el enlace del video** |

### Demo interactiva en Appetize.io

**Enlace público de la aplicación:** **PENDIENTE: pega aquí tu enlace de Appetize.io**

Para crear o actualizar el enlace, consulta [Publicar la app en Appetize.io](#publicar-la-app-en-appetizeio).

## Objetivo

Crear una aplicación de reproducción de videos verticales que practique el uso de widgets,
administración de estado con Provider, navegación entre secciones y personalización de la
interfaz. TokTik amplía el ejercicio con favoritos persistentes, fuentes de video remotas y
temas que cambian según la temporada.

## Funcionalidades

- **Discover:** feed vertical de videos locales con reproducción, descripción, contador de
  vistas y controles de interacción.
- **For You:** feed vertical que obtiene videos de YouTube, Dailymotion y Vimeo. Requiere
  internet; si una fuente falla, la pantalla permite reintentar la carga.
- **Favorites:** colección de videos marcados con “me gusta”. Los likes y los favoritos se
  conservan al cerrar y volver a abrir la aplicación.
- **Navegación lateral:** cambia entre Discover, For You y Favorites deslizando la pantalla
  o seleccionando una sección en la barra superior.
- **Reproducción:** permite silenciar o activar el audio. El estado de silencio se recuerda
  entre sesiones; en web el audio inicia silenciado por las restricciones de reproducción
  automática del navegador.
- **Descripción expandible:** las descripciones largas se pueden desplegar desde el control
  «… más».
- **Temas por temporada:** la paleta, tipografía, iconos y jingle cambian entre Normal,
  Halloween, Navidad y San Valentín.
- **Persistencia local:** preferencias, likes, favoritos y ajustes se guardan con
  `SharedPreferences`.

## Tecnologías y arquitectura

- Flutter y Dart
- Provider (`ChangeNotifier`) para el estado de la interfaz
- `video_player` para reproducir videos
- `SharedPreferences` para conservar preferencias y favoritos
- `youtube_explode_dart` y datasources propios para resolver videos remotos
- `audioplayers` para reproducir los jingles de temporada

El código está organizado por responsabilidades:

| Capa | Ubicación | Responsabilidad |
| --- | --- | --- |
| Configuración | `lib/config/` | Temas, formatos, iconos y reproducción de audio |
| Dominio | `lib/domain/` | Entidades y contratos de repositorios y datasources |
| Infraestructura | `lib/infrastructure/` | Datasources, modelos, mappers y repositorios |
| Presentación | `lib/presentation/` | Providers, pantallas y widgets de la interfaz |

La composición de dependencias se realiza en `lib/main.dart`: se crean los datasources,
se inyectan en los repositorios y estos se proporcionan a la interfaz con `MultiProvider`.
Para consultar los diagramas y los flujos principales, revisa
[`docs/ARQUITECTURA.md`](docs/ARQUITECTURA.md).

## Requisitos y ejecución

Necesitas tener instalado Flutter y un emulador, dispositivo o navegador compatible.

```powershell
cd "Practica 04\toktik"
flutter pub get
flutter run
```

### Videos de prueba

Los siguientes videos se incluyen como **material de prueba** para mostrar ejemplos de
contenido y probar la reproducción:

- ▶️ [Ver los dos videos en el navegador](https://edwinhdzcm.github.io/Practicas_DMI_230425/Practica%2004/videos/)
- ⬇️ [Abrir o descargar video de prueba 1](../videos/1.mp4)
- ⬇️ [Abrir o descargar video de prueba 2](../videos/2.mp4)


## Temas por temporada

La temporada automática se determina usando la fecha del dispositivo. Cada periodo inicia
diez días antes de la celebración:

| Temporada | Periodo automático |
| --- | --- |
| Halloween | 21 de octubre – 2 de noviembre |
| Navidad | 15 de diciembre – 6 de enero |
| San Valentín | 4 – 15 de febrero |
| Normal | Resto del año |

Para probar un tema sin cambiar la fecha, abre el selector con el icono de paleta en la
parte superior y elige una temporada. La opción **Automático** vuelve a usar la fecha del
dispositivo. Al cambiar de temporada se actualizan el tema y el jingle; el icono del
launcher también se sincroniza al iniciar la aplicación.

### Probar cambiando la fecha del emulador Android

Es más sencillo probar los temas desde el selector de la aplicación. Si necesitas verificar
el comportamiento asociado a la fecha del dispositivo, puedes cambiarla en un emulador
Android con `adb`:

```powershell
adb root
adb shell settings put global auto_time 0
# Formato: MMDDhhmmAAAA.ss -> 21 de octubre de 2026, 15:00
adb shell date 102115002026.00
```

Reinicia la aplicación para comprobar el splash y el icono del launcher. Para restaurar la
fecha automática:

```powershell
adb shell settings put global auto_time 1
```

En un dispositivo físico normalmente se necesita acceso root; puedes cambiar la fecha desde
**Ajustes > Sistema > Fecha y hora**.

### Jingles de temporada

Los jingles se encuentran en `assets/audio/`:

| Archivo | Temporada |
| --- | --- |
| `normal.wav` | Normal |
| `halloween.wav` | Halloween |
| `christmas.wav` | Navidad |
| `valentine.wav` | San Valentín |

Los audios actuales son originales y se pueden regenerar con Python, sin dependencias
adicionales:

```powershell
python tool/generate_season_audio.py
```

Si reemplazas los jingles, conserva sus nombres y vuelve a compilar la aplicación. Si
utilizas música de terceros, verifica su licencia y agrega los créditos correspondientes.

## Publicar la app en Appetize.io

[Appetize.io](https://appetize.io) permite compartir una demo de Android que se ejecuta en
el navegador. Para publicar una versión:

1. Crea una cuenta en [appetize.io/signup](https://appetize.io/signup).
2. Desde la carpeta del proyecto TokTik, genera el APK de lanzamiento:

   ```powershell
   flutter build apk --release
   ```

   El archivo se genera en `build\app\outputs\flutter-apk\app-release.apk`.

3. Sube el APK desde [appetize.io/upload](https://appetize.io/upload), seleccionando
   Android. También puedes usar el script incluido para subirlo desde PowerShell:

   ```powershell
   $env:APPETIZE_API_TOKEN = "tu_token"
   .\tool\upload_to_appetize.ps1
   ```

   El token se genera en **Account > API Tokens**. Mantenlo privado y no lo publiques en
   este README ni en el repositorio.

4. Copia el enlace público que proporciona Appetize y reemplaza el espacio de
   [Demo interactiva en Appetize.io](https://appetize.io/app/b_rpg6l36vjfaqozqzpvkld7a6hq) al inicio de este
   documento. Si vuelves a subir una versión, puedes actualizar la misma app pasando
   `-PublicKey <publicKey>` al script.

Ten en cuenta que los videos de **For You** requieren internet. El HLS de Dailymotion no
se reproduce en web; para probar ese contenido, utiliza Android o iOS. En Appetize, el
audio del jingle puede requerir activar el altavoz del visor.


## Diagrama de la app

![Vista previa del diagrama](https://edwinhdzcm.github.io/Practicas_DMI_230425/Practica04/archify/toktik-providers.html)
![Vista previa del diagrama](https://edwinhdzcm.github.io/Practicas_DMI_230425/Practica04/toktik-general.html)

## Créditos

Práctica académica de la asignatura **Desarrollo Móvil Integral**. Los videos de la
aplicación se usan como contenido de demostración; verifica que tienes permiso para
redistribuir cualquier medio que agregues al repositorio o a la demo pública.
