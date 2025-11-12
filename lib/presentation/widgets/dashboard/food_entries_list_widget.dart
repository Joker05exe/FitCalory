import 'package:flutter/material.dart';
import '../../../domain/entities/daily_summary.dart';
import '../../../domain/entities/food_entry.dart';
import '../../../domain/entities/enums.dart';

class FoodEntriesListWidget extends StatelessWidget {
  final DailySummary summary;

  const FoodEntriesListWidget({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    if (summary.entries.isEmpty) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No hay alimentos registrados',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Agrega tu primer alimento del día',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Group entries by meal type
    final groupedEntries = _groupEntriesByMealType(summary.entries);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alimentos del día',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...MealType.values.map((mealType) {
          final entries = groupedEntries[mealType] ?? [];
          if (entries.isEmpty) return const SizedBox.shrink();
          
          return _MealSection(
            mealType: mealType,
            entries: entries,
          );
        }),
      ],
    );
  }

  Map<MealType, List<FoodEntry>> _groupEntriesByMealType(
    List<FoodEntry> entries,
  ) {
    final grouped = <MealType, List<FoodEntry>>{};
    
    for (final entry in entries) {
      grouped.putIfAbsent(entry.mealType, () => []).add(entry);
    }
    
    return grouped;
  }
}

class _MealSection extends StatelessWidget {
  final MealType mealType;
  final List<FoodEntry> entries;

  const _MealSection({
    required this.mealType,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.calculatedValues.calories,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getMealIcon(mealType),
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getMealName(mealType),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Text(
                  '${totalCalories.toInt()} kcal',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          
          // Food entries
          ...entries.asMap().entries.map((mapEntry) {
            final index = mapEntry.key;
            final entry = mapEntry.value;
            final isLast = index == entries.length - 1;
            
            return _FoodEntryItem(
              entry: entry,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  IconData _getMealIcon(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return Icons.wb_sunny;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
      case MealType.snack:
        return Icons.cookie;
    }
  }

  String _getMealName(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return 'Desayuno';
      case MealType.lunch:
        return 'Almuerzo';
      case MealType.dinner:
        return 'Cena';
      case MealType.snack:
        return 'Snack';
    }
  }
}

class _FoodEntryItem extends StatefulWidget {
  final FoodEntry entry;
  final bool isLast;

  const _FoodEntryItem({
    required this.entry,
    required this.isLast,
  });

  @override
  State<_FoodEntryItem> createState() => _FoodEntryItemState();
}

class _FoodEntryItemState extends State<_FoodEntryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Dismissible(
          key: Key(widget.entry.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Theme.of(context).colorScheme.error,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Eliminar alimento'),
                content: const Text(
                  '¿Estás seguro de que deseas eliminar este alimento?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text('Eliminar'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            // TODO: Implement delete functionality with BLoC
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.entry.food.name} eliminado'),
                action: SnackBarAction(
                  label: 'Deshacer',
                  onPressed: () {
                    // TODO: Implement undo functionality
                  },
                ),
              ),
            );
          },
          child: InkWell(
            onTap: () {
              // TODO: Navigate to edit screen
              _showEditDialog(context);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: widget.isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.2),
                        ),
                      ),
              ),
              child: Row(
                children: [
                  // Food icon/image placeholder
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.fastfood,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Food info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.entry.food.name,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.entry.quantity.toInt()} ${widget.entry.unit}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                        ),
                        const SizedBox(height: 4),
                        _buildMacrosRow(context),
                      ],
                    ),
                  ),
                  
                  // Calories
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.entry.calculatedValues.calories.toInt()}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      Text(
                        'kcal',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacrosRow(BuildContext context) {
    final macros = widget.entry.calculatedValues.macros;
    
    return Row(
      children: [
        _buildMacroChip(
          context,
          'P: ${macros.protein.toInt()}g',
          const Color(0xFF2196F3),
        ),
        const SizedBox(width: 4),
        _buildMacroChip(
          context,
          'C: ${macros.carbohydrates.toInt()}g',
          const Color(0xFF4CAF50),
        ),
        const SizedBox(width: 4),
        _buildMacroChip(
          context,
          'G: ${macros.fats.toInt()}g',
          const Color(0xFFFFC107),
        ),
      ],
    );
  }

  Widget _buildMacroChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar alimento'),
        content: const Text(
          'La funcionalidad de edición estará disponible próximamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
