# TPV Proyect

Este repositorio contiene una aplicación Flutter (TPV) en desarrollo.

## Descripción

TPV Proyect es una aplicación creada con Flutter para gestionar un terminal punto de venta (TPV). Incluye interfaces para ventas, gestión de inventario y configuración básica. Este README describe cómo configurar, ejecutar y contribuir al proyecto.

## Requisitos

- Flutter SDK (estable) — https://docs.flutter.dev/get-started/install
- Dart (incluido con Flutter)
- Android Studio o Visual Studio Code (opcional, recomendado)
- Dispositivo físico o emulador Android/iOS para pruebas

Verifica la instalación de Flutter con:

```bash
flutter --version
```

## Instalación y ejecución

1. Clona el repositorio:

```bash
git clone https://github.com/gabrielramos02/tpv_proyect.git
cd tpv_proyect
```

2. Instala las dependencias:

```bash
flutter pub get
```

3. Ejecuta la aplicación en un emulador o dispositivo conectado:

```bash
flutter run
```

4. Para ejecutar tests:

```bash
flutter test
```

5. Para crear un APK de producción (Android):

```bash
flutter build apk --release
```

Para guías completas de despliegue, consulta:
- Android: https://docs.flutter.dev/deployment/android
- iOS: https://docs.flutter.dev/deployment/ios

## Estructura del proyecto (resumen)

- android/ — configuración y código nativo Android
- ios/ — configuración y código nativo iOS
- lib/ — código fuente Dart (lógica y UI)
  - main.dart — punto de entrada
- test/ — pruebas unitarias y de widgets
- assets/ — imágenes, fuentes y otros recursos

Adapta esta lista si tu proyecto tiene una organización distinta.

## Comandos útiles

- Obtener dependencias: `flutter pub get`
- Ejecutar en modo debug: `flutter run`
- Ejecutar pruebas: `flutter test`
- Analizar código: `flutter analyze`
- Formatear código: `dart format .`

## Buenas prácticas

- No subir credenciales ni claves al repositorio. Usa variables de entorno o un servicio de secretos.
- Trabaja en ramas separadas y abre Pull Requests para cambios significativos.
- Añade pruebas para la lógica crítica (pagos, inventario, cálculos).
- Mantén las dependencias actualizadas y revisa breaking changes antes de actualizar.

## Contribuciones

1. Crea una rama nueva desde `main`: `git checkout -b feat/nueva-caracteristica`
2. Haz los cambios y añade tests cuando proceda.
3. Abre un Pull Request describiendo los cambios y pruebas realizadas.

## Licencia

Indica aquí la licencia del proyecto (por ejemplo, MIT). Si aún no tienes una, añade un archivo `LICENSE` con la licencia elegida.

## Contacto

Si tienes dudas o quieres colaborar, abre un issue o contacta al mantenedor del repositorio.
