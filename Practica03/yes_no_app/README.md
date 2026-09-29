
# Práctica 03: yes_no_app

Aplicación de chat hecha con Flutter. El usuario puede enviar mensajes y, cuando uno termina en signo de interrogación (`?`), la aplicación consulta la API [yesno.wtf](https://yesno.wtf/api) y muestra una respuesta (`Sí`, `No` o `Tal vez`) junto con la imagen recibida.

## Funcionalidades

- Muestra dos mensajes iniciales y conserva la conversación en memoria mientras la aplicación está abierta.
- Permite enviar mensajes desde el campo de texto o el botón de envío.
- Ignora los mensajes vacíos y consulta la API solo si el mensaje termina en `?`.
- Elige una respuesta forzada al azar: 40 % `yes`, 40 % `no` y 20 % `maybe`.
- Muestra la hora de envío en cada burbuja y una imagen en los mensajes de respuesta.
- Usa Provider para compartir y actualizar el estado de la conversación.

## Requisitos

- Flutter y Dart instalados. La versión de Dart configurada por el proyecto es `^3.13.3`.
- Un emulador, simulador o dispositivo compatible.
- Conexión a internet para consultar la API y descargar la imagen de respuesta.

## Instalación y ejecución

Desde esta carpeta (`Practica03/yes_no_app`), ejecuta:

```bash
flutter pub get
flutter run
```

Para ejecutar las pruebas del proyecto:

```bash
flutter test
```

## Flujo de una respuesta

1. El usuario escribe y envía un mensaje.
2. `ChatProvider` elimina espacios sobrantes, agrega el mensaje y actualiza la interfaz.
3. Si el texto termina en `?`, `GetYesNoAnswer` hace una petición HTTP con Dio a `https://yesno.wtf/api` y envía el parámetro `force`.
4. `YesNoModel` convierte el JSON recibido en el mensaje del chat: traduce la respuesta al español y conserva la URL de la imagen.
5. El proveedor agrega la respuesta y desplaza la lista hasta el final.

La petición requiere acceso a internet. Actualmente no hay una respuesta alternativa implementada si la API no está disponible.

## Estructura del proyecto

```text
lib/
├── main.dart                              # Inicializa la app, el tema y Provider
├── config/
│   ├── helpers/get_yes_no_answer.dart     # Petición HTTP a yesno.wtf
│   └── theme/app_theme.dart               # Tema y color principal
├── domain/entities/message.dart           # Entidad y autor del mensaje
├── infrastructure/models/yes_no_model.dart # Conversión de JSON a mensaje
└── presentation/
	├── providers/chat_provider.dart       # Estado y lógica de la conversación
	├── screens/chat/chat_screen.dart      # Pantalla principal del chat
	└── widgets/
		├── chat/                          # Burbujas propias y de respuesta
		└── shared/message_field_box.dart  # Campo de entrada y envío

assets/icons.jpg                           # Imagen fuente del icono de la app
```

## Capturas de pantalla

Crea la carpeta `docs/images/`, guarda ahí tus capturas y actualiza los nombres si hace falta. Estas líneas muestran cómo insertarlas en Markdown:


![Icono de la aplicación](/Practica03/yes_no_app/img/img01.png)
![Conversación con respuesta](/Practica03/yes_no_app/img/img02.png)

## Icono de la aplicación

El archivo `assets/icons.jpg` es la imagen fuente configurada para los iconos de Android y iOS mediante `flutter_launcher_icons`. Después de cambiarla, desde la carpeta del proyecto ejecuta:

```bash
flutter pub get
dart run flutter_launcher_icons
```

Luego recompila y reinstala la aplicación para que el launcher del dispositivo cargue los iconos nuevos. Esto cambia el icono de la aplicación, no agrega la imagen a la pantalla del chat.
