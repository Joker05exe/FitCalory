# 🔧 Guía de Integración - Sistema de Favoritos

## 📋 Pasos para Integrar Completamente

### 1. Actualizar el Home Screen con Pestaña de Favoritos

Edita `lib/presentation/screens/home/home_screen.dart`:

```dart
import '../favorites/favorites_screen.dart';

// En el NavigationBar, añade:
NavigationDestination(
  icon: Icon(Icons.favorite_border),
  selectedIcon: Icon(Icons.favorite),
  label: 'Favoritos',
),

// En el body, añade:
case 3: // O el índice que corresponda
  return BlocProvider(
    create: (_) => sl<FavoritesBloc>()..add(LoadFavorites()),
    child: const FavoritesScreen(),
  );
```

### 2. Añadir Botón de Favorito en Food Detail Screen

Edita `lib/presentation/screens/food/food_detail_screen.dart`:

```dart
import '../../widgets/common/favorite_button.dart';
import '../../bloc/favorites/favorites_bloc.dart';

// En el AppBar:
AppBar(
  title: Text('Detalles del Alimento'),
  actions: [
    BlocProvider(
      create: (_) => sl<FavoritesBloc>()..add(LoadFavorites()),
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FavoriteButton(
          food: widget.food,
          size: 24,
          showBackground: true,
        ),
      ),
    ),
  ],
),
```

### 3. Registrar FavoritesBloc en Providers Globales

Edita `lib/presentation/app.dart`:

```dart
import 'bloc/favorites/favorites_bloc.dart';

// En los providers:
BlocProvider<FavoritesBloc>(
  create: (_) => sl<FavoritesBloc>()..add(LoadFavorites()),
),
```

### 4. Añadir Ruta de Navegación

Edita `lib/presentation/app.dart` o tu archivo de rutas:

```dart
'/favorites': (context) => BlocProvider(
  create: (_) => sl<FavoritesBloc>()..add(LoadFavorites()),
  child: const FavoritesScreen(),
),
```

### 5. Inicializar DatabaseHelper

Edita `lib/core/di/injection_container.dart`:

Ya está hecho ✅ - El DatabaseHelper se registra automáticamente

### 6. Crear Tabla de Favoritos en la Base de Datos

Edita `lib/data/datasources/local/database_helper.dart`:

Asegúrate de que la tabla `foods` tenga la columna `is_favorite`:

```dart
await db.execute('''
  CREATE TABLE foods(
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    brand TEXT,
    calories_per_100g REAL NOT NULL,
    protein REAL NOT NULL,
    carbohydrates REAL NOT NULL,
    fats REAL NOT NULL,
    fiber REAL NOT NULL,
    barcode TEXT,
    last_updated INTEGER NOT NULL,
    is_favorite INTEGER DEFAULT 0
  )
''');
```

## 🎨 Uso de Componentes Visuales

### GlassCard

```dart
import 'package:calorie_tracker/presentation/widgets/common/glass_card.dart';

GlassCard(
  margin: EdgeInsets.all(16),
  padding: EdgeInsets.all(20),
  borderRadius: 20,
  blur: 10,
  opacity: 0.1,
  child: Column(
    children: [
      Text('Contenido'),
      // ... más widgets
    ],
  ),
)
```

### AnimatedGradientButton

```dart
import 'package:calorie_tracker/presentation/widgets/common/animated_gradient_button.dart';
import 'package:calorie_tracker/core/theme/app_theme.dart';

AnimatedGradientButton(
  text: 'Guardar',
  icon: Icons.save,
  gradient: AppTheme.primaryGradient,
  height: 56,
  borderRadius: 16,
  isLoading: false,
  onPressed: () {
    // Acción
  },
)
```

### FavoriteButton

```dart
import 'package:calorie_tracker/presentation/widgets/common/favorite_button.dart';

// Con fondo
FavoriteButton(
  food: myFood,
  size: 28,
  showBackground: true,
)

// Sin fondo (solo icono)
FavoriteButton(
  food: myFood,
  size: 24,
  showBackground: false,
)
```

## 🧪 Testing

### Probar Favoritos

```dart
// 1. Navegar a búsqueda de alimentos
// 2. Seleccionar un alimento
// 3. Tocar el botón de favorito (debe animarse)
// 4. Ir a la pestaña de favoritos
// 5. Verificar que el alimento aparece
// 6. Tocar el botón de favorito nuevamente
// 7. Verificar que desaparece de la lista
```

### Probar Persistencia

```dart
// 1. Añadir varios alimentos a favoritos
// 2. Cerrar completamente la app
// 3. Abrir la app nuevamente
// 4. Ir a favoritos
// 5. Verificar que todos los favoritos siguen ahí
```

## 🐛 Troubleshooting

### Error: "FavoritesBloc not found"

**Solución:** Asegúrate de que FavoritesBloc está registrado en el injection container y proporcionado en el árbol de widgets.

```dart
// En injection_container.dart
sl.registerFactory(() => FavoritesBloc(sl()));

// En el widget
BlocProvider(
  create: (_) => sl<FavoritesBloc>()..add(LoadFavorites()),
  child: YourWidget(),
)
```

### Error: "Table foods has no column named is_favorite"

**Solución:** Necesitas migrar la base de datos o eliminar y recrear.

```dart
// Opción 1: Incrementar versión de DB
static const int _version = 2; // Era 1

// Opción 2: Eliminar app y reinstalar (solo desarrollo)
// Opción 3: Añadir migración en onUpgrade
```

### Los favoritos no se sincronizan

**Solución:** Asegúrate de llamar a `LoadFavorites()` después de cada cambio.

```dart
context.read<FavoritesBloc>().add(ToggleFavorite(food));
// El bloc automáticamente recarga después del toggle
```

## 📱 Ejemplo Completo de Integración

```dart
// home_screen.dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const DashboardScreen(),
          const HistoryScreen(),
          const StatsScreen(),
          BlocProvider(
            create: (_) => sl<FavoritesBloc>()..add(LoadFavorites()),
            child: const FavoritesScreen(),
          ),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
```

## ✅ Checklist de Integración

- [ ] FavoritesBloc registrado en injection_container.dart
- [ ] DatabaseHelper inicializado
- [ ] Tabla foods tiene columna is_favorite
- [ ] FavoritesScreen añadida al NavigationBar
- [ ] FavoriteButton añadido en FoodDetailScreen
- [ ] Rutas de navegación configuradas
- [ ] Probado añadir favoritos
- [ ] Probado quitar favoritos
- [ ] Probado persistencia (cerrar/abrir app)
- [ ] Probado animaciones
- [ ] Probado en tema oscuro

## 🎯 Resultado Esperado

Después de la integración completa:

1. ✅ Los usuarios pueden marcar alimentos como favoritos
2. ✅ Los favoritos persisten entre sesiones
3. ✅ Hay una pestaña dedicada para ver favoritos
4. ✅ Las animaciones funcionan suavemente
5. ✅ El botón de favorito muestra el estado correcto
6. ✅ La interfaz es atractiva y moderna
