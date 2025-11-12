# 🚀 Guía de Despliegue - Calorie Tracker App

## Pre-requisitos

### Herramientas Necesarias
- Flutter SDK 3.0.0+
- Android Studio / Xcode (para builds nativos)
- Cuenta de desarrollador (Google Play / App Store)

### Configuración del Entorno
```bash
# Verificar instalación de Flutter
flutter doctor

# Actualizar Flutter
flutter upgrade

# Limpiar proyecto
flutter clean
flutter pub get
```

## 📱 Android

### 1. Configurar Signing

#### Crear Keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

#### Configurar key.properties
Crear `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>/upload-keystore.jks
```

#### Actualizar build.gradle
Ya configurado en `android/app/build.gradle`

### 2. Build Release

#### APK (para testing)
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

#### App Bundle (para Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### 3. Optimizaciones

#### Reducir tamaño
```bash
# Build con split per ABI
flutter build apk --release --split-per-abi

# Genera 3 APKs:
# - app-armeabi-v7a-release.apk
# - app-arm64-v8a-release.apk
# - app-x86_64-release.apk
```

#### ProGuard
Ya configurado en `android/app/build.gradle`:
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```

### 4. Testing del Build

```bash
# Instalar APK en dispositivo
flutter install --release

# O manualmente
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 5. Publicar en Google Play

#### Preparar Assets
- Ícono de app (512x512 PNG)
- Feature graphic (1024x500 PNG)
- Screenshots (mínimo 2 por dispositivo)
- Video promocional (opcional)

#### Crear Listing
1. Ir a [Google Play Console](https://play.google.com/console)
2. Crear nueva aplicación
3. Completar información:
   - Título: "Calorie Tracker"
   - Descripción corta (80 caracteres)
   - Descripción completa (4000 caracteres)
   - Categoría: Salud y bienestar
   - Clasificación de contenido
   - Política de privacidad

#### Subir Build
1. Ir a "Producción" > "Crear nueva versión"
2. Subir app-release.aab
3. Completar notas de versión
4. Revisar y publicar

## 🖥️ Desktop (Linux/Windows)

### Linux

#### Build
```bash
flutter build linux --release
```
Output: `build/linux/x64/release/bundle/`

#### Crear Instalador (opcional)
```bash
# Usando snapcraft
snapcraft

# O crear .deb
dpkg-deb --build build/linux/x64/release/bundle calorie-tracker.deb
```

### Windows

#### Build
```bash
flutter build windows --release
```
Output: `build/windows/runner/Release/`

#### Crear Instalador
Usar Inno Setup o NSIS para crear instalador .exe

#### Publicar en Microsoft Store
1. Crear package MSIX
```bash
flutter pub run msix:create
```
2. Subir a [Partner Center](https://partner.microsoft.com/)

## 🍎 iOS (Futuro)

### Configuración
```bash
# Abrir proyecto en Xcode
open ios/Runner.xcworkspace

# Configurar:
# - Bundle Identifier
# - Team
# - Signing & Capabilities
```

### Build
```bash
flutter build ios --release
```

### Publicar en App Store
1. Archivar en Xcode
2. Subir a App Store Connect
3. Completar metadata
4. Enviar para revisión

## 🔧 Configuración Pre-Despliegue

### 1. Actualizar Versión

En `pubspec.yaml`:
```yaml
version: 1.0.0+1  # version+buildNumber
```

### 2. Verificar Permisos

#### Android (`AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
```

### 3. Configurar Íconos

```bash
# Instalar flutter_launcher_icons
flutter pub add dev:flutter_launcher_icons

# Configurar en pubspec.yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"

# Generar
flutter pub run flutter_launcher_icons
```

### 4. Splash Screen

```bash
# Instalar flutter_native_splash
flutter pub add dev:flutter_native_splash

# Configurar en pubspec.yaml
flutter_native_splash:
  color: "#6750A4"
  image: assets/splash/splash_logo.png

# Generar
flutter pub run flutter_native_splash:create
```

## 📊 Checklist Pre-Lanzamiento

### Funcionalidad
- [ ] Todas las features funcionan correctamente
- [ ] No hay crashes en uso normal
- [ ] Datos se persisten correctamente
- [ ] Navegación fluida
- [ ] Responsive en diferentes tamaños

### Performance
- [ ] Tiempo de carga < 3 segundos
- [ ] Animaciones suaves (60 FPS)
- [ ] Uso de memoria optimizado
- [ ] Tamaño de APK < 50MB

### Seguridad
- [ ] No hay API keys hardcodeadas
- [ ] Datos sensibles encriptados
- [ ] Permisos justificados
- [ ] HTTPS para todas las conexiones

### Legal
- [ ] Política de privacidad publicada
- [ ] Términos de servicio
- [ ] Licencias de código abierto
- [ ] Clasificación de contenido

### Marketing
- [ ] Screenshots de calidad
- [ ] Descripción atractiva
- [ ] Keywords optimizados
- [ ] Video demo (opcional)

## 🔍 Testing Pre-Lanzamiento

### Testing Manual
```bash
# Build de prueba
flutter build apk --release

# Instalar en múltiples dispositivos
# - Android 8.0 (mínimo)
# - Android 13+ (actual)
# - Diferentes tamaños de pantalla
```

### Casos de Prueba Críticos
1. ✅ Onboarding completo
2. ✅ Registro de alimento
3. ✅ Visualización de dashboard
4. ✅ Navegación entre tabs
5. ✅ Edición de perfil
6. ✅ Persistencia de datos
7. ✅ Rotación de pantalla
8. ✅ Modo oscuro/claro

## 📈 Post-Lanzamiento

### Monitoreo
- Configurar Firebase Crashlytics
- Configurar Firebase Analytics
- Monitorear reviews en stores
- Responder a feedback de usuarios

### Actualizaciones
```bash
# Incrementar versión
# pubspec.yaml: version: 1.0.1+2

# Build y publicar
flutter build appbundle --release
# Subir a Play Console
```

### Métricas Clave
- Instalaciones diarias
- Usuarios activos (DAU/MAU)
- Retención (D1, D7, D30)
- Crash rate
- Rating promedio

## 🆘 Troubleshooting

### Build Falla

```bash
# Limpiar completamente
flutter clean
rm -rf build/
flutter pub get
flutter build apk --release
```

### Problemas de Signing

```bash
# Verificar keystore
keytool -list -v -keystore ~/upload-keystore.jks

# Verificar configuración
cat android/key.properties
```

### APK muy grande

```bash
# Analizar tamaño
flutter build apk --analyze-size

# Optimizar
flutter build apk --release --split-per-abi
```

## 📞 Recursos

### Documentación
- [Flutter Deployment](https://docs.flutter.dev/deployment)
- [Google Play Console](https://support.google.com/googleplay/android-developer)
- [App Store Connect](https://developer.apple.com/app-store-connect/)

### Herramientas
- [App Icon Generator](https://appicon.co/)
- [Screenshot Generator](https://www.appstorescreenshot.com/)
- [ASO Tools](https://www.apptweak.com/)

## ✅ Checklist Final

Antes de publicar:
- [ ] Versión actualizada en pubspec.yaml
- [ ] Build release exitoso
- [ ] Testing en dispositivos reales
- [ ] Screenshots preparados
- [ ] Descripción escrita
- [ ] Política de privacidad publicada
- [ ] Keystore respaldado de forma segura
- [ ] Monitoreo configurado

**¡Listo para lanzar! 🚀**

---

**Última actualización:** Noviembre 2024  
**Versión del documento:** 1.0
