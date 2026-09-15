# Practica 02

## Hello World App
Esta carpeta corresponde a un proyecto desarrollado en Flutter dentro de la asignatura de Desarrollo Móvil Integral. La finalidad principal es aprender el uso de widgets, el manejo del estado y la construcción de una interfaz sencilla pero funcional en una aplicación móvil.

## ¿De qué trata esta aplicación?

La app es una pequeña aplicación de contador. Su funcionamiento es muy básico:

- Muestra un número inicial en pantalla.
- Permite aumentar el valor con un botón.
- Permite disminuir el valor con otro botón.
- Cambia de color según el valor del contador:
  - positivo -> verde
  - negativo -> rojo
  - cero -> azul

Esto sirve para practicar conceptos clave de Flutter como:

- `StatefulWidget`
- `setState()`
- diseño con `Scaffold`, `AppBar`, `FloatingActionButton`
- uso de temas visuales
- integración de fuentes personalizadas con `google_fonts`

## Estructura de la carpeta

```text
hello_world_app/
├── lib/
│   ├── main.dart
│   └── presentation/
│       └── screens/
│           └── counter/
│               └── counter_function_screen.dart
├── pubspec.yaml
├── README.md
├── analysis_options.yaml
└── android/ , ios/ , web/ , windows/ , linux/ , macos/
```

### Archivos principales

- `lib/main.dart`: punto de entrada de la aplicación.
- `lib/presentation/screens/counter/counter_function_screen.dart`: contiene la lógica y la interfaz visual del contador.
- `pubspec.yaml`: define dependencias del proyecto, como `flutter` y `google_fonts`.

## ¿Qué hace exactamente el código?

La aplicación inicia en `main.dart`, donde se crea la instancia de `MyApp` y se configura el tema principal. Luego se despliega la pantalla `CounterFunctionScreen`, la cual:

1. mantiene el valor del contador en un estado interno,
2. actualiza el valor cuando se presiona un botón,
3. cambia el color del texto según el número actual,
4. muestra una interfaz simple y moderna con Material 3.

## Cómo ejecutar el proyecto

Desde la carpeta del proyecto, usa los siguientes comandos:

```bash
flutter pub get
flutter run
```

Si deseas abrirlo en un emulador o dispositivo conectado, asegúrate de tener Flutter configurado correctamente en tu entorno.

## Capturas de pantalla

Puedes agregar imágenes al README con enlaces relativos o URLs externas.

### Opción 1: imágenes dentro de la carpeta del proyecto

Crea una carpeta como esta:

```text
assets/images/
```

Y luego inserta imágenes así:

```markdown
![Pantalla principal](assets/images/pantalla_principal.png)
![Contador en funcionamiento](assets/images/contador.png)
```

### Opción 2: imágenes desde una URL

```markdown
![Vista previa](https://via.placeholder.com/800x500.png?text=Hello+World+App)
```

### Ejemplo visual

```markdown
![Vista de la aplicación](https://via.placeholder.com/800x500.png?text=Counter+Screen)
```

## Resumen

La carpeta `hello_world_app` es una práctica inicial de Flutter que permite comprender cómo se construye una app móvil desde cero, con una interfaz interactiva y manejo de estados. Es una base ideal para comenzar a trabajar con aplicaciones móviles más complejas en el futuro.

---

Si quieres, puedo ayudarte a crear también una versión más formal del README para entregar en clase o una versión más visual con una tabla de contenido y secciones adicionales.