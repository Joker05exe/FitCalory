# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.0-beta] - 2024-11-10

### 🎉 Lanzamiento Inicial - MVP Funcional

#### ✅ Agregado

**Core Features:**
- Sistema completo de gestión de perfil de usuario
  - Onboarding con formulario multi-paso
  - Cálculo automático de calorías (fórmula Harris-Benedict)
  - Configuración de objetivos (perder peso, mantener, ganar músculo)
  - Edición de perfil y objetivos
  
- Búsqueda y registro manual de alimentos
  - Base de datos local con 20+ alimentos comunes
  - Búsqueda en tiempo real con autocompletado
  - Selector de porciones con múltiples unidades
  - Cálculo automático de valores nutricionales
  - Categorización por tipo de comida
  
- Dashboard interactivo
  - Resumen diario de calorías (consumidas vs objetivo)
  - Gráfico circular de distribución de macronutrientes
  - Lista de alimentos del día agrupados por comida
  - Indicador de calorías restantes
  
- Sistema de historial
  - Vista de calendario con navegación por fechas
  - Resumen diario detallado
  - Gráficos de tendencia semanal y mensual
  
- Estadísticas y analytics
  - Promedios de calorías por período (7, 30, 90 días)
  - Métricas de adherencia a objetivos
  - Distribución de macronutrientes
  - Generación automática de insights
  - Racha de días consecutivos
  
- Diseño responsivo
  - Adaptación automática para móvil, tablet y desktop
  - Bottom navigation bar para móvil
  - Side navigation rail para desktop
  - Layouts optimizados por tamaño de pantalla

**Arquitectura:**
- Clean Architecture con 3 capas bien definidas
- BLoC pattern para state management
- Dependency injection con get_it
- Repository pattern para abstracción de datos
- Use case pattern para lógica de negocio

**Infraestructura:**
- Almacenamiento local con Hive
- Splash screen con routing inteligente
- Sistema de navegación con tabs
- FAB con menú de opciones
- Tema Material Design 3 (claro/oscuro)

**BLoCs Implementados:**
- UserProfileBloc (gestión de perfil)
- FoodSearchBloc (búsqueda de alimentos)
- FoodLogBloc (registro de comidas)
- DashboardBloc (resumen diario)
- AnalyticsBloc (estadísticas y métricas)

**Pantallas Implementadas:**
- SplashScreen
- WelcomeScreen
- UserProfileSetupScreen
- HomeScreen (con navegación)
- DashboardScreen
- FoodSearchScreen
- FoodDetailScreen
- HistoryScreen
- StatsScreen
- ProfileScreen
- GoalsSettingsScreen

**Widgets Reutilizables:**
- ResponsiveScaffold
- ResponsiveContainer
- BreakpointBuilder
- CalorieProgressCard
- MacrosChartCard
- FoodEntriesListWidget
- AverageCaloriesCard
- GoalAdherenceCard
- InsightsCard
- WeightProgressChart
- MacrosDistributionCard
- CalendarWidget
- DailySummaryCard
- WeeklyChartWidget

**Documentación:**
- README.md completo
- IMPLEMENTATION_SUMMARY.md
- QUICK_START.md
- NEXT_STEPS.md
- PROJECT_STRUCTURE.md
- TESTING_GUIDE.md
- Especificaciones completas (requirements.md, design.md, tasks.md)

#### 🔧 Técnico

**Dependencias Principales:**
- flutter_bloc: ^8.1.3
- get_it: ^7.6.4
- hive: ^2.2.3
- hive_flutter: ^1.1.0
- dartz: ^0.10.1
- equatable: ^2.0.5
- fl_chart: ^0.66.0
- google_fonts: ^6.1.0
- intl: ^0.18.1

**Configuración:**
- Análisis estático configurado
- Linting rules aplicadas
- Type adapters de Hive generados
- Assets configurados (seed data)

#### 📝 Notas

**Funcionalidades Implementadas:**
- ✅ Gestión de perfil de usuario
- ✅ Búsqueda y registro manual de alimentos
- ✅ Dashboard con visualizaciones
- ✅ Historial y calendario
- ✅ Estadísticas y analytics
- ✅ Diseño responsivo
- ✅ Navegación principal

**Funcionalidades Pendientes:**
- 🚧 Escaneo de códigos QR
- 🚧 Análisis de imágenes con IA
- 🚧 Sincronización offline
- 🚧 Notificaciones
- 🚧 API remota
- 🚧 Tests

**Limitaciones Conocidas:**
- Base de datos limitada a 20 alimentos (expandible)
- Sin sincronización en la nube
- Sin autenticación de usuarios
- Sin notificaciones push
- Sin análisis de imágenes
- Sin escaneo de códigos QR

**Mejoras Futuras:**
- Agregar más alimentos a la base de datos
- Implementar caché de imágenes
- Optimizar queries con índices
- Agregar lazy loading en listas
- Implementar pagination en historial
- Mejorar animaciones y transiciones

## [Unreleased]

### 🚧 En Desarrollo

**Próximas Features:**
- Escaneo de códigos QR con Open Food Facts
- Mejoras de UX (estados vacíos, animaciones)
- Tests unitarios básicos

### 📋 Planeado

**Versión 1.1.0:**
- Análisis de imágenes con IA
- Sistema de notificaciones
- Sincronización offline

**Versión 1.2.0:**
- Backend con API REST
- Autenticación de usuarios
- Backup en la nube

**Versión 2.0.0:**
- Features sociales (compartir progreso)
- Integración con wearables
- Planificador de comidas
- Tracking de agua y sueño

---

## Tipos de Cambios

- `Agregado` - Para nuevas funcionalidades
- `Cambiado` - Para cambios en funcionalidades existentes
- `Obsoleto` - Para funcionalidades que serán removidas
- `Removido` - Para funcionalidades removidas
- `Corregido` - Para corrección de bugs
- `Seguridad` - Para vulnerabilidades de seguridad

## Versionado

Este proyecto usa [Semantic Versioning](https://semver.org/lang/es/):
- **MAJOR** - Cambios incompatibles en la API
- **MINOR** - Nuevas funcionalidades compatibles
- **PATCH** - Correcciones de bugs compatibles

---

**Mantenido por:** Equipo de Desarrollo  
**Última actualización:** 2024-11-10
