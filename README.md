# Caja de Herramientas — App Multi-API (Flutter)

App Flutter con 8 vistas que consumen distintas APIs públicas, hecha para la tarea del curso (ITLA).

## Vistas incluidas

1. **Inicio** — pantalla principal con el ícono de "caja de herramientas" y menú a las demás vistas.
2. **Predicción de género** — `https://api.genderize.io/?name=...` → fondo azul si es masculino, rosado si es femenino.
3. **Predicción de edad** — `https://api.agify.io/?name=...` → clasifica en Joven (<30), Adulto (30-59) o Anciano (60+), con ícono según el caso.
4. **Universidades por país** — `https://adamix.net/proxy.php?country=...` → nombre, dominio y enlace web de cada universidad.
5. **Clima en RD** — usa [Open-Meteo](https://open-meteo.com) (gratis, sin API key) para el clima actual de Santo Domingo.
6. **Buscar Pokémon** — `https://pokeapi.co/api/v2/pokemon/...` → imagen oficial, experiencia base, habilidades y sonido (`cries.latest`).
7. **Noticias WordPress** — usa el REST API oficial de WordPress: `https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3&_embed` → título, resumen y enlace "Visitar" de las últimas 3 noticias.
8. **Acerca de** — foto y datos de contacto del desarrollador.

## Cómo ejecutarla

Requisitos: tener el [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (versión estable reciente).

```bash
cd tarea_app
flutter pub get
flutter run
```

## Antes de entregar: cosas que debes personalizar

1. **Vista "Acerca de" (`lib/screens/about_screen.dart`)**
   - Cambia `nombre`, `carrera`, `email`, `telefono`, `linkedin` y `github` por tus datos reales.
   - Agrega tu foto en `assets/images/mi_foto.jpg` y reemplaza el `CircleAvatar` por:
     ```dart
     backgroundImage: AssetImage('assets/images/mi_foto.jpg'),
     ```

2. **Ícono de la app (debe ser tu foto)**
   - Coloca tu foto cuadrada (idealmente 1024x1024 px) en `assets/images/app_icon.png`.
   - Corre:
     ```bash
     flutter pub get
     dart run flutter_launcher_icons
     ```
   - Esto genera automáticamente los íconos para Android e iOS a partir de tu foto (ya configurado en `pubspec.yaml`).

3. **Imagen de la caja de herramientas (vista 1)**
   - Actualmente se muestra un ícono estilizado (`Icons.handyman_rounded`) dentro de una tarjeta.
   - Si prefieres una foto real, agrégala en `assets/images/toolbox.jpg` y en `lib/main.dart` reemplaza el bloque del `Icon` por:
     ```dart
     Image.asset('assets/images/toolbox.jpg', fit: BoxFit.cover)
     ```

4. **Foro de WordPress**
   - El API usado es el oficial de WordPress.org:
     `https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3&_embed`
   - No olvides publicarlo en el foro del curso como pide la tarea.

## Subir el proyecto a GitHub

```bash
cd tarea_app
git init
git add .
git commit -m "Primer commit: app multi-API en Flutter"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git
git push -u origin main
```
(Crea antes el repositorio vacío en GitHub y reemplaza la URL de `origin` por la tuya.)

## Estructura del proyecto

```
lib/
  main.dart                  # Pantalla principal / menú
  services/
    api_service.dart         # Todas las llamadas HTTP centralizadas
  screens/
    gender_screen.dart       # Vista 2
    age_screen.dart          # Vista 3
    universities_screen.dart # Vista 4
    weather_screen.dart      # Vista 5
    pokemon_screen.dart      # Vista 6
    news_screen.dart         # Vista 7
    about_screen.dart        # Vista 8
  widgets/
    result_card.dart         # Componentes reutilizables (tarjeta, error)
```

## Paquetes usados

- `http` — llamadas a las APIs REST.
- `audioplayers` — reproducir el sonido (cry) del Pokémon.
- `url_launcher` — abrir enlaces de universidades, noticias y contacto.
- `intl` — formateo de fecha en español en la vista de clima.
- `flutter_launcher_icons` (dev) — generar el ícono de la app desde tu foto.
