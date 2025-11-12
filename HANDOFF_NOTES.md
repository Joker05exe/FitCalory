# 🤝 Notas de Traspaso - Calorie Tracker App

## Para el Próximo Desarrollador

Bienvenido al proyecto! Este documento te ayudará a continuar donde se dejó.

---

## 📍 Estado Actual

**Versión:** 1.0.0-beta  
**Fecha:** Noviembre 2024  
**Estado:** MVP Completado (70%)

### ✅ Lo que está hecho
- Arquitectura Clean completa
- 5 BLoCs funcionando
- 11 pantallas implementadas
- Base de datos local con Hive
- 20 alimentos precargados
- Documentación completa

### 🚧 Lo que falta
- Escaneo QR
- Análisis IA
- Tests
- Notificaciones

---

## 🚀 Cómo Empezar

### 1. Setup Inicial (10 minutos)

```bash
# Clonar y setup
git clone <repo>
cd calorie_tracker
flutter pub get

# Ejecutar
flutter run
```

### 2. Explorar el Código (30 minutos)

**Orden recomendado:**
1. Lee `README.md`
2. Lee `QUICK_START.md`
3. Explora `lib/main.dart`
4. Revisa `lib/core/di/injection_container.dart`
5. Mira un BLoC completo: `lib/presentation/bloc/user_profile/`
6. Revisa una pantalla: `lib/presentation/screens/dashboard/`

### 3. Ejecutar y Probar (20 minutos)

1. Ejecuta la app
2. Completa el onboarding
3. Busca y registra un alimento
4. Navega por todas las pantallas
5. Verifica que todo funcione

---

## 🎯 Próxima Tarea Recomendada

### Tarea 11: Escaneo QR (Prioridad Alta)

**Tiempo estimado:** 3-4 días  
**Dificultad:** Media

#### Pasos:

1. **Día 1: Setup y Permisos**
   ```yaml
   # Agregar a pubspec.yaml
   dependencies:
     mobile_scanner: ^3.5.5
   ```
   
   ```xml
   <!-- Agregar a AndroidManifest.xml -->
   <uses-permission android:name="android.permission.CAMERA" />
   ```

2. **Día 2: Pantalla de Escaneo**
   - Crear `lib/presentation/screens/qr/qr_scanner_screen.dart`
   - Implementar vista previa de cámara
   - Agregar overlay con guía visual

3. **Día 3: Integración Open Food Facts**
   - Crear `lib/data/datasources/remote/open_food_facts_service.dart`
   - Implementar búsqueda por código de barras
   - Parsear respuesta a modelo Food

4. **Día 4: Flujo Completo**
   - Conectar scanner con FoodDetailScreen
   - Manejar productos no encontrados
   - Testing completo

#### Archivos a Crear:
```
lib/presentation/screens/qr/
  ├── qr_scanner_screen.dart
  └── qr_result_screen.dart (opcional)

lib/data/datasources/remote/
  └── open_food_facts_service.dart

lib/presentation/bloc/qr_scanner/
  ├── qr_scanner_bloc.dart
  ├── qr_scanner_event.dart
  └── qr_scanner_state.dart
```

#### Referencias:
- Open Food Facts API: https://world.openfoodfacts.org/data
- mobile_scanner docs: https://pub.dev/packages/mobile_scanner
- Ejemplo en el proyecto: `lib/presentation/screens/food/food_search_screen.dart`

---

## 💡 Tips Importantes

### Arquitectura

**Siempre sigue este flujo:**
```
UI → BLoC → Use Case → Repository → Data Source
```

**Para agregar una feature:**
1. Define entidades en `domain/entities/`
2. Crea repositorio en `domain/repositories/`
3. Implementa use case en `domain/usecases/`
4. Implementa repositorio en `data/repositories/`
5. Crea BLoC en `presentation/bloc/`
6. Crea pantalla en `presentation/screens/`
7. Registra en `core/di/injection_container.dart`

### BLoC Pattern

**Estructura estándar:**
```dart
// Event
class MyEvent extends Equatable {}

// State
class MyState extends Equatable {}

// BLoC
class MyBloc extends Bloc<MyEvent, MyState> {
  final MyUseCase useCase;
  
  MyBloc({required this.useCase}) : super(MyInitial()) {
    on<MyEvent>(_onMyEvent);
  }
  
  Future<void> _onMyEvent(
    MyEvent event,
    Emitter<MyState> emit,
  ) async {
    emit(MyLoading());
    final result = await useCase(params);
    result.fold(
      (failure) => emit(MyError(failure.message)),
      (data) => emit(MyLoaded(data)),
    );
  }
}
```

### Testing

**Cuando implementes tests:**
```dart
// Unit test example
test('should return data when call is successful', () async {
  // Arrange
  when(mockRepository.getData())
    .thenAnswer((_) async => Right(testData));
  
  // Act
  final result = await useCase(NoParams());
  
  // Assert
  expect(result, Right(testData));
  verify(mockRepository.getData());
});
```

---

## 🐛 Problemas Conocidos

### 1. Hive Initialization
**Problema:** A veces Hive no inicializa correctamente  
**Solución:** Desinstalar y reinstalar la app

### 2. Hot Reload con BLoC
**Problema:** Hot reload puede causar problemas con BLoCs  
**Solución:** Usar Hot Restart (Shift+R)

### 3. Assets no cargan
**Problema:** JSON de alimentos no se carga  
**Solución:** Verificar que esté en `pubspec.yaml` y hacer `flutter clean`

---

## 📚 Recursos Útiles

### Documentación del Proyecto
- **[DOCS_INDEX.md](DOCS_INDEX.md)** - Índice completo
- **[QUICK_START.md](QUICK_START.md)** - Guía rápida
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Estructura
- **[design.md](.kiro/specs/calorie-tracker-app/design.md)** - Diseño técnico

### Ejemplos en el Código
- **BLoC completo:** `lib/presentation/bloc/user_profile/`
- **Repositorio:** `lib/data/repositories/user_profile_repository_impl.dart`
- **Use Case:** `lib/domain/usecases/calculate_calorie_goal.dart`
- **Pantalla:** `lib/presentation/screens/dashboard/dashboard_screen.dart`

### Enlaces Externos
- [Flutter Docs](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [Hive Docs](https://docs.hivedb.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 🔍 Debugging Tips

### Ver logs de BLoC
```dart
// En main.dart
Bloc.observer = SimpleBlocObserver();

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
```

### Inspeccionar Hive
```dart
// Ver contenido de una box
final box = Hive.box<UserProfileModel>('user_profiles');
print(box.values);
```

### Performance
```bash
# Ejecutar con performance overlay
flutter run --profile
# Presiona 'P' para mostrar overlay
```

---

## ✅ Checklist para Nueva Feature

Antes de hacer commit:

- [ ] Código compila sin errores
- [ ] Sigue Clean Architecture
- [ ] BLoC implementado correctamente
- [ ] Manejo de errores incluido
- [ ] Estados de carga implementados
- [ ] Documentación inline agregada
- [ ] Probado manualmente
- [ ] Actualizado CHANGELOG.md
- [ ] Actualizado tasks.md

---

## 🤔 ¿Dudas?

### Arquitectura
→ Ver `design.md` sección "Architecture"

### Implementación
→ Buscar ejemplos similares en el código

### BLoC
→ Ver `lib/presentation/bloc/user_profile/` como referencia

### Hive
→ Ver `lib/data/repositories/user_profile_repository_impl.dart`

---

## 📞 Contacto

Si tienes dudas o encuentras problemas:

1. Revisa la documentación en `DOCS_INDEX.md`
2. Busca ejemplos en el código existente
3. Revisa los comentarios `TODO:` en el código
4. Consulta el `design.md` para decisiones arquitectónicas

---

## 🎯 Objetivos a Corto Plazo

### Esta Semana
1. Familiarizarte con el código
2. Ejecutar y probar la app
3. Leer documentación clave

### Próximas 2 Semanas
1. Implementar escaneo QR
2. Agregar tests básicos
3. Mejorar UX

### Próximo Mes
1. Análisis IA
2. Notificaciones
3. Optimización

---

## 💪 ¡Éxito!

El proyecto tiene una base sólida. La arquitectura está bien definida, el código es limpio y la documentación es completa.

**Confía en la arquitectura y sigue los patrones existentes.**

¡Mucha suerte con el desarrollo! 🚀

---

**Preparado por:** Equipo de Desarrollo  
**Fecha:** Noviembre 2024  
**Versión:** 1.0

**¡Bienvenido al equipo! 🎉**
