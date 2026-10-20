/// Datos "en duro" de los videos locales (assets/videos/N.mp4).
const String _lorem =
    'Este es un video de ejemplo para probar la descripción extensa. '
    'Cuando el texto supera el número de líneas permitido se recorta y '
    'aparece la opción "... más"; al tocarla se despliega todo el contenido '
    'dentro de un área con desplazamiento vertical, de modo que se puede '
    'leer sin salir del video. Incluye varias oraciones a propósito para que '
    'la descripción sea lo bastante larga y se note el scroll. ';

final List<Map<String, dynamic>> videoPosts = [
  {
    'name': 'Subiendo escaleras automáticas',
    'description': _lorem,
    'videoUrl': 'assets/videos/1.mp4',
    'likes': 23230,
    'views': 1523,
  },
  {
    'name': 'Planta apreciada por peatones',
    'description': 'Una planta que atrae todas las miradas en plena calle.',
    'videoUrl': 'assets/videos/2.mp4',
    'likes': 24230,
    'views': 1343,
  },
  {
    'name': 'Que borroso veo todo!',
    'description': _lorem + _lorem,
    'videoUrl': 'assets/videos/3.mp4',
    'likes': 21564320,
    'views': 123563,
  },
  {
    'name': '¿Esto es trigo? que interesante',
    'description': 'Campo de cultivo visto de cerca.',
    'videoUrl': 'assets/videos/4.mp4',
    'likes': 320,
    'views': 2300,
  },
  {
    'name': 'El COVID no me afecta',
    'description': _lorem,
    'videoUrl': 'assets/videos/5.mp4',
    'likes': 3230,
    'views': 31030,
  },
  {
    'name': 'No quiero ir a trabajar hoy señor Stark',
    'description': 'Lunes por la mañana, ya sabes cómo es.',
    'videoUrl': 'assets/videos/6.mp4',
    'likes': 10,
    'views': 330,
  },
  {
    'name': 'Limpiar nunca fue tan divertido',
    'description': _lorem,
    'videoUrl': 'assets/videos/7.mp4',
    'likes': 1320,
    'views': 33032,
  },
  {
    'name': '¿Ya llegamos a la India?... umm si',
    'description': 'Un viaje largo, pero valió la pena.',
    'videoUrl': 'assets/videos/8.mp4',
    'likes': 342,
    'views': 3332,
  },
];
