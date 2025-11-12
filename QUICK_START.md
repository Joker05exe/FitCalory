# 🚀 Guía Rápida - Calorie Tracker App

## Inicio Rápido

### 1. Instalación (5 minutos)

```bash
# Clonar el repositorio
git clone <repository-url>
cd calorie_tracker

# Instalar dependencias
flutter pub get

# Ejecutar la app
flutter run
```

¡Eso es todo! La app se inicializará automáticamente con datos de ejemplo.

## 🎯 Flujo de Usuario

### Primera Vez
1. **Splash Screen** → Detecta que no hay perfil
2. **Welcome Screen** → Introducción a la app
3. **Onboarding** → Formulario de perfil (nombre, edad, peso, altura, objetivo)
4. **Home/Dashboard** → Listo para usar

### Uso Normal
1. **Dashboard** → Ver resumen del día
2. **FAB (+)** → Agregar alimento
3. **Búsqueda** → Buscar "arroz", "pollo", etc.
4. **Detalle** → Ajustar porción y registrar
5. **Dashboard actualizado** → Ver progreso

## 📁 Estructura Clave

```
lib/
├── main.dart                          # Entry point
├── presentation/
│   ├── app.dart                       # App widget con BLoC providers
│   ├── screens/
│   │   ├── splash/                    # Splash screen
│   │   ├── onboarding/                # Welcome y setup
│   │   ├── home/                      # Home con navegación
│   │   ├── dashboard/                 # Dashboard principal
│   │   ├── food/                      # Búsqueda y detalle
│   │   ├── history/                   # Historial
│   │   ├── stats/                     # Estadísticas
│   │   └── profile/                   # Perfil
│   └── bloc/                          # State management
├── domain/
│   ├── entities/                      # Modelos de negocio
│   ├── repositories/                  # Interfaces
│   └── usecases/                      # Lógica de negocio
├── data/
│   ├── models/                        # Modelos de datos
│   ├── repositories/                  # Implementaciones
│   └── datasources/local/             # Hive
└── core/
    ├── di/                            # Dependency injection
    ├── routes/                        # Navegación
    └── theme/                         # Tema
```

## 🔧 Comandos Útiles

### Desarrollo
```bash
# Ejecutar en modo debug
flutter run

# Hot reload (en la app corriendo)
# Presiona 'r' en la terminal

# Hot restart
# Presiona 'R' en la terminal

# Ver logs
flutter logs
```

### Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# Linux
flutter build linux --release

# Windows
flutter build windows --release
```

### Limpieza
```bash
# Limpiar build
flutter clean

# Reinstalar dependencias
flutter pub get
```

## 🎨 Personalización Rápida

### Cambiar Colores
Edita `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFF6750A4); // Tu color aquí
```

### Agregar Alimentos
Edita `assets/data/foods_seed.json`:
```json
{
  "id": "food_021",
  "name": "Tu Alimento",
  "caloriesPer100g": 100,
  ...
}
```

### Modificar Cálculo de Calorías
Edita `lib/domain/usecases/calculate_calorie_goal.dart`

## 🐛 Solución de Problemas

### La app no inicia
```bash
flutter clean
flutter pub get
flutter run
```

### Error de Hive
```bash
# Eliminar datos de Hive
# Android
adb shell run-as com.example.calorie_tracker rm -rf /data/data/com.example.calorie_tracker/app_flutter/

# O simplemente desinstalar y reinstalar la app
```

### No aparecen alimentos en búsqueda
- Verifica que `assets/data/foods_seed.json` esté en pubspec.yaml
- Reinstala la app para ejecutar el seed nuevamente

## 📱 Testing en Dispositivos

### Android
```bash
# Listar dispositivos
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device-id>
```

### Desktop
```bash
# Linux
flutter run -d linux

# Windows
flutter run -d windows
```

## 🔑 Características Principales

### ✅ Implementadas
- ✅ Perfil de usuario con cálculo automático de calorías
- ✅ Búsqueda de alimentos (20+ alimentos precargados)
- ✅ Registro de comidas con porciones personalizables
- ✅ Dashboard con gráficos de macronutrientes
- ✅ Historial con calendario
- ✅ Estadísticas y métricas
- ✅ Diseño responsivo (móvil/tablet/desktop)

### 🚧 Próximamente
- 🚧 Escaneo de códigos QR
- 🚧 Análisis de imágenes con IA
- 🚧 Notificaciones
- 🚧 Sincronización en la nube

## 💡 Tips de Desarrollo

### Agregar un Nuevo BLoC
1. Crear archivos en `lib/presentation/bloc/mi_bloc/`
   - `mi_bloc.dart`
   - `mi_event.dart`
   - `mi_state.dart`
2. Registrar en `lib/core/di/injection_container.dart`
3. Agregar provider en `lib/presentation/app.dart`

### Agregar una Nueva Pantalla
1. Crear en `lib/presentation/screens/mi_screen/`
2. Agregar ruta en `lib/core/routes/app_router.dart`
3. Navegar con `Navigator.pushNamed(context, AppRouter.miScreen)`

### Agregar un Nuevo Repositorio
1. Definir interface en `lib/domain/repositories/`
2. Implementar en `lib/data/repositories/`
3. Registrar en `lib/core/di/injection_container.dart`

## 📚 Recursos

### Documentación del Proyecto
- `README.md` - Descripción general
- `IMPLEMENTATION_SUMMARY.md` - Estado de implementación
- `PROJECT_STRUCTURE.md` - Estructura detallada
- `.kiro/specs/calorie-tracker-app/` - Especificaciones completas

### Flutter
- [Flutter Docs](https://docs.flutter.dev/)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Hive Database](https://docs.hivedb.dev/)

## 🎓 Conceptos Clave

### Clean Architecture
- **Domain:** Lógica de negocio pura (sin dependencias de Flutter)
- **Data:** Implementaciones de repositorios y fuentes de datos
- **Presentation:** UI y state management

### BLoC Pattern
- **Events:** Acciones del usuario
- **States:** Estados de la UI
- **BLoC:** Lógica que transforma eventos en estados

### Dependency Injection
- `get_it` gestiona todas las dependencias
- Registradas en `injection_container.dart`
- Accesibles con `sl<MiClase>()`

## ⚡ Atajos de Desarrollo

### VS Code
- `Ctrl+.` - Quick fixes
- `F5` - Debug
- `Shift+F5` - Stop debug
- `Ctrl+Shift+P` - Command palette

### Android Studio
- `Alt+Enter` - Quick fixes
- `Shift+F10` - Run
- `Ctrl+F9` - Build

## 🎉 ¡Listo!

Ya puedes empezar a desarrollar. Si tienes dudas:
1. Revisa la documentación en `.kiro/specs/`
2. Busca ejemplos en el código existente
3. Los comentarios `TODO:` indican áreas de mejora

**¡Happy Coding! 🚀**
