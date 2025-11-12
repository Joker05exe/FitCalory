import 'package:flutter/material.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/responsive_container.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/food.dart';
import '../../../domain/repositories/weight_repository.dart';
import '../../../data/repositories/custom_food_repository.dart';
import '../dashboard/dashboard_screen.dart';
import '../history/history_screen.dart';
import '../stats/stats_screen.dart';
import '../weight/weight_tracker_screen.dart';
import '../food/food_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = const [
    NavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
    ),
    NavigationItem(
      label: 'Alimentos',
      icon: Icons.restaurant_outlined,
      selectedIcon: Icons.restaurant,
    ),
    NavigationItem(
      label: 'Peso',
      icon: Icons.monitor_weight_outlined,
      selectedIcon: Icons.monitor_weight,
    ),
    NavigationItem(
      label: 'Historial',
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
    ),
    NavigationItem(
      label: 'Estadísticas',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: _getTitle(),
      currentIndex: _currentIndex,
      onNavigationChanged: (index) {
        setState(() => _currentIndex = index);
      },
      navigationItems: _navigationItems,
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.profile);
          },
        ),
      ],
      floatingActionButton: _currentIndex == 0
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: _showAddFoodOptions,
                backgroundColor: Colors.transparent,
                elevation: 0,
                icon: const Icon(Icons.add_rounded, size: 28),
                label: const Text(
                  'Agregar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
      body: ResponsiveContainer(
        child: _buildBody(),
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Alimentos';
      case 2:
        return 'Mi Peso';
      case 3:
        return 'Historial';
      case 4:
        return 'Estadísticas';
      default:
        return 'Calorie Tracker';
    }
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return _buildFoods();
      case 2:
        return WeightTrackerScreen(repository: sl<WeightRepository>());
      case 3:
        return const HistoryScreen();
      case 4:
        return const StatsScreen();
      default:
        return const Center(child: Text('Página no encontrada'));
    }
  }

  Widget _buildFoods() {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Mis Alimentos'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.pushNamed(context, AppRouter.addCustomFood);
                  setState(() {}); // Refresh after adding
                },
                tooltip: 'Añadir alimento personalizado',
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildQuickAccessCard(),
                const SizedBox(height: 16),
                _buildFavoritesSection(),
                const SizedBox(height: 16),
                _buildCustomFoodsSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acceso Rápido',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.search,
                    label: 'Buscar',
                    color: Colors.blue,
                    onTap: () => Navigator.pushNamed(context, AppRouter.foodSearch),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.qr_code_scanner,
                    label: 'Escanear',
                    color: Colors.purple,
                    onTap: () => Navigator.pushNamed(context, AppRouter.barcodeScanner),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.camera_alt,
                    label: 'Foto IA',
                    color: Colors.green,
                    onTap: () => Navigator.pushNamed(context, AppRouter.photoAnalyzer),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return FutureBuilder<List<Food>>(
      future: CustomFoodRepository().getFavorites(),
      builder: (context, snapshot) {
        final favorites = snapshot.data ?? [];
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Favoritos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    if (favorites.isNotEmpty)
                      Chip(
                        label: Text('${favorites.length}'),
                        backgroundColor: Colors.amber[100],
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (favorites.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.star_border,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No tienes favoritos aún',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Marca alimentos como favoritos para acceso rápido',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...favorites.map((food) => _buildFoodTile(food)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomFoodsSection() {
    return FutureBuilder<List<Food>>(
      future: CustomFoodRepository().getCustomFoods(),
      builder: (context, snapshot) {
        final customFoods = snapshot.data ?? [];
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Mis Alimentos',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (customFoods.isNotEmpty)
                          Chip(
                            label: Text('${customFoods.length}'),
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () async {
                            await Navigator.pushNamed(context, AppRouter.addCustomFood);
                            setState(() {});
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Añadir'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (customFoods.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No tienes alimentos personalizados',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crea alimentos con valores nutricionales exactos',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.pushNamed(context, AppRouter.addCustomFood);
                            setState(() {});
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Crear Alimento'),
                        ),
                      ],
                    ),
                  )
                else
                  ...customFoods.map((food) => _buildFoodTile(food)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFoodTile(Food food) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          food.isFavorite ? Icons.star : Icons.restaurant,
          color: food.isFavorite ? Colors.amber : Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        food.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${food.caloriesPer100g.toInt()} kcal/100g • ${food.brand ?? "Sin marca"}',
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailScreen(food: food),
          ),
        );
        setState(() {}); // Refresh after viewing
      },
    );
  }

  void _showAddFoodOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agregar alimento',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Elige cómo quieres registrar tu comida',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
              _buildAddOption(
                context,
                icon: Icons.star,
                title: 'Favoritos',
                subtitle: 'Acceso rápido a tus alimentos frecuentes',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA726), Color(0xFFFB8C00)],
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to favorites
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Marca alimentos como favoritos desde su detalle'),
                    ),
                  );
                },
              ),
              _buildAddOption(
                context,
                icon: Icons.search_rounded,
                title: 'Búsqueda manual',
                subtitle: 'Buscar en la base de datos',
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.foodSearch);
                },
              ),
              _buildAddOption(
                context,
                icon: Icons.qr_code_scanner_rounded,
                title: 'Escanear código de barras',
                subtitle: 'Usar cámara o introducir manualmente',
                gradient: const LinearGradient(
                  colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.barcodeScanner);
                },
              ),
              _buildAddOption(
                context,
                icon: Icons.camera_alt_rounded,
                title: 'Foto con IA',
                subtitle: 'Analizar alimento con cámara',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.photoAnalyzer);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
