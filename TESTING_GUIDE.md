# Guía de Pruebas - Calorie Tracker App

## Requisitos Previos

- Flutter SDK instalado (versión 3.0 o superior)
- Un dispositivo físico o emulador configurado
- Editor de código (VS Code, Android Studio, etc.)

## Pasos para Probar la Aplicación

### 1. Verificar Instalación de Flutter

```bash
flutter doctor
```

Asegúrate de que todos los componentes necesarios estén instalados.

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Generar Código de Hive

La aplicación usa Hive para persistencia local. Necesitas generar los adaptadores:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Verificar que No Hay Errores

```bash
flutter analyze
```

### 5. Ejecutar la Aplicación

**En un emulador/dispositivo conectado:**
```bash
flutter run
```

**Para una plataforma específica:**
```bash
# Android
flutter run -d android

# iOS (solo en macOS)
flutter run -d ios

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# Web
flutter run -d chrome
```

## Funcionalidades a Probar

### ✅ Onboarding (Primera Vez)
1. Al abrir la app por primera vez, deberías ver la pantalla de configuración inicial
2. Completa el formulario con:
   - Nombre
   - Edad
   - Peso actual
   - Altura
   - Nivel de actividad
   - Objetivo (perder peso, mantener, ganar peso)
3. Verifica que se calcule automáticamente la meta de calorías

### ✅ Dashboard
1. Después del onboarding, deberías ver el dashboard con:
   - Tarjeta de progreso de calorías (circular)
   - Gráfico de distribución de macronutrientes
   - Lista de entradas de alimentos (vacía inicialmente)
2. Verifica que los datos del perfil se muestren correctamente

### ✅ Navegación
1. Prueba la barra de navegación inferior:
   - Dashboard (inicio)
   - Historial
   - Estadísticas
   - Perfil
2. Verifica que cada pantalla se cargue sin errores

### ✅ Perfil
1. Ve a la sección de Perfil
2. Verifica que se muestren tus datos
3. Intenta editar la configuración de metas
4. Verifica que los cambios se guarden

### ✅ Historial
1. Ve a la sección de Historial
2. Deberías ver:
   - Calendario para seleccionar fechas
   - Resúmenes diarios
   - Gráficos semanales

### ✅ Estadísticas
1. Ve a la sección de Estadísticas
2. Deberías ver:
   - Distribución de macronutrientes
   - Progreso de peso
   - Adherencia a metas
   - Insights y recomendaciones

## Problemas Comunes

### Error: "Hive adapters not found"
**Solución:** Ejecuta el generador de código:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error: "Package not found"
**Solución:** Reinstala las dependencias:
```bash
flutter pub get
```

### La app se cierra al iniciar
**Solución:** Verifica los logs:
```bash
flutter run --verbose
```

### Errores de compilación
**Solución:** Limpia el proyecto y reconstruye:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## Modo Debug vs Release

### Debug (desarrollo)
```bash
flutter run
```
- Hot reload habilitado
- Más lento pero con herramientas de desarrollo

### Release (producción)
```bash
flutter run --release
```
- Optimizado para rendimiento
- Sin herramientas de desarrollo

## Verificar Rendimiento

```bash
flutter run --profile
```

Esto te permite usar el DevTools para analizar el rendimiento.

## Logs y Debugging

Para ver logs detallados:
```bash
flutter logs
```

## Próximos Pasos

Una vez que verifiques que todo funciona correctamente, podemos continuar con:
- **Tarea 7.1:** Crear base de datos de alimentos local con datos seed
- **Tarea 7.2:** Implementar búsqueda de alimentos
- **Tarea 7.3:** Crear pantalla de detalle y registro

## Notas Importantes

- La primera vez que ejecutes la app, se creará la base de datos Hive local
- Los datos se persisten localmente en el dispositivo
- No hay datos de alimentos precargados aún (eso es parte de la tarea 7.1)
- La app está diseñada para ser responsiva en diferentes tamaños de pantalla

## Contacto y Soporte

Si encuentras algún error o problema, anota:
1. El mensaje de error completo
2. Los pasos para reproducir el problema
3. La plataforma donde ocurre (Android, iOS, Web, etc.)
