# PrincessPlataforma - App Android

## Descripción
App Android que carga la Plataforma Princess (web app de GitHub Pages) en un WebView.
Cualquier cambio que hagas en los HTML y subas a GitHub se ve automáticamente en la app sin necesidad de actualizar el APK.

## Cómo funciona la sincronización
- La app carga siempre: `https://centralcomprasprincesscanarias.github.io/princess-data/hub.html`
- Si cambias el HTML en GitHub Pages → la app lo ve al instante al recargar
- **No hay que actualizar el APK para cambios de diseño o contenido**

## Características
- WebView a pantalla completa sin barra de URLs
- Pull-to-refresh (desliza hacia abajo para recargar)
- Barra de progreso dorada mientras carga
- Soporte completo para subida de fotos (módulo Incidencias)
- Navegación con botón atrás del dispositivo
- Página de error offline con botón reintentar
- Pantalla oscura Princess (#1A1510)

## Abrir en Android Studio
1. Descomprime el ZIP
2. File → Open → selecciona la carpeta `PrincessPlataforma`
3. Espera que Gradle sincronice
4. Run → Run 'app'

## Cambiar la URL del hub
En `MainActivity.kt` línea:
```kotlin
private const val HUB_URL = "https://centralcomprasprincesscanarias.github.io/princess-data/hub.html"
```
