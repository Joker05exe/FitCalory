import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/food.dart';
import '../../../domain/entities/food_entry.dart';
import '../../../domain/entities/macronutrients.dart';
import '../../../data/repositories/custom_food_repository.dart';
import '../../bloc/food_log/food_log_bloc.dart';
import '../../bloc/food_log/food_log_event.dart';
import '../../bloc/food_log/food_log_state.dart';

class FoodDetailScreen extends StatefulWidget {
  final Food food;

  const FoodDetailScreen({
    super.key,
    required this.food,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late ServingSize _selectedServing;
  double _quantity = 1.0;
  MealType _selectedMealType = MealType.lunch;
  late bool _isFavorite;
  final _repository = CustomFoodRepository();
  final _quantityController = TextEditingController();
  final _gramsController = TextEditingController();
  bool _useDirectGrams = false;

  @override
  void initState() {
    super.initState();
    _selectedServing = widget.food.servingSizes.first;
    _isFavorite = widget.food.isFavorite;
    _quantityController.text = _quantity.toStringAsFixed(1);
    _gramsController.text = (_quantity * _selectedServing.grams).toStringAsFixed(0);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _gramsController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    try {
      // Primero guardar el alimento si no existe
      await _repository.saveFood(widget.food, isCustom: false);
      
      // Luego toggle favorito
      await _repository.toggleFavorite(widget.food.id);
      
      setState(() {
        _isFavorite = !_isFavorite;
      });
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                _isFavorite ? Icons.star : Icons.star_border,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                _isFavorite 
                  ? 'Añadido a favoritos' 
                  : 'Eliminado de favoritos',
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: _isFavorite ? Colors.orange : Colors.grey[700],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  NutritionalValues _calculateNutritionalValues() {
    final multiplier = (_quantity * _selectedServing.grams) / 100;
    return NutritionalValues(
      calories: widget.food.caloriesPer100g * multiplier,
      macros: Macronutrients(
        protein: widget.food.macrosPer100g.protein * multiplier,
        carbohydrates: widget.food.macrosPer100g.carbohydrates * multiplier,
        fats: widget.food.macrosPer100g.fats * multiplier,
        fiber: widget.food.macrosPer100g.fiber * multiplier,
      ),
    );
  }

  void _logFood() {
    final calculatedValues = _calculateNutritionalValues();
    final entry = FoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user', // TODO: Get from user profile
      food: widget.food,
      quantity: _quantity * _selectedServing.grams,
      unit: 'g',
      calculatedValues: calculatedValues,
      timestamp: DateTime.now(),
      mealType: _selectedMealType,
      source: EntrySource.manual,
    );

    context.read<FoodLogBloc>().add(LogFoodEntry(entry));
  }

  @override
  Widget build(BuildContext context) {
    final calculatedValues = _calculateNutritionalValues();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Alimento'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? Colors.amber : null,
            ),
            onPressed: _toggleFavorite,
            tooltip: _isFavorite ? 'Quitar de favoritos' : 'Añadir a favoritos',
          ),
        ],
      ),
      body: BlocListener<FoodLogBloc, FoodLogState>(
        listener: (context, state) {
          if (state is FoodLogSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is FoodLogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Food name and brand
              Text(
                widget.food.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (widget.food.brand != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.food.brand!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                ),
              ],
              const SizedBox(height: 24),

              // Serving size selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tamaño de porción',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<ServingSize>(
                        value: _selectedServing,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: widget.food.servingSizes
                            .map((serving) => DropdownMenuItem(
                                  value: serving,
                                  child: Text(
                                      '${serving.name} (${serving.grams}g)'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedServing = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Cantidad',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _useDirectGrams = !_useDirectGrams;
                                if (_useDirectGrams) {
                                  _gramsController.text = (_quantity * _selectedServing.grams).toStringAsFixed(0);
                                } else {
                                  _quantityController.text = _quantity.toStringAsFixed(1);
                                }
                              });
                            },
                            icon: Icon(_useDirectGrams ? Icons.scale : Icons.restaurant),
                            label: Text(_useDirectGrams ? 'Gramos' : 'Porciones'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_useDirectGrams)
                        // Input directo de gramos
                        TextField(
                          controller: _gramsController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Gramos',
                            suffixText: 'g',
                            helperText: 'Escribe la cantidad exacta en gramos',
                          ),
                          onChanged: (value) {
                            final grams = double.tryParse(value);
                            if (grams != null && grams > 0) {
                              setState(() {
                                _quantity = grams / _selectedServing.grams;
                              });
                            }
                          },
                        )
                      else
                        // Selector de porciones con botones
                        Column(
                          children: [
                            TextField(
                              controller: _quantityController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Porciones',
                                helperText: 'Escribe o usa los botones',
                              ),
                              onChanged: (value) {
                                final quantity = double.tryParse(value);
                                if (quantity != null && quantity > 0) {
                                  setState(() {
                                    _quantity = quantity;
                                    _gramsController.text = (_quantity * _selectedServing.grams).toStringAsFixed(0);
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton.filled(
                                  onPressed: () {
                                    if (_quantity > 0.5) {
                                      setState(() {
                                        _quantity -= 0.5;
                                        _quantityController.text = _quantity.toStringAsFixed(1);
                                        _gramsController.text = (_quantity * _selectedServing.grams).toStringAsFixed(0);
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                  tooltip: '-0.5',
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        _quantity.toStringAsFixed(1),
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                      Text(
                                        '${(_quantity * _selectedServing.grams).toStringAsFixed(0)}g',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                IconButton.filled(
                                  onPressed: () {
                                    setState(() {
                                      _quantity += 0.5;
                                      _quantityController.text = _quantity.toStringAsFixed(1);
                                      _gramsController.text = (_quantity * _selectedServing.grams).toStringAsFixed(0);
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                  tooltip: '+0.5',
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Meal type selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo de comida',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<MealType>(
                        value: _selectedMealType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: MealType.values
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(_getMealTypeName(type)),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedMealType = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nutritional information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información Nutricional',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      _NutrientRow(
                        label: 'Calorías',
                        value: '${calculatedValues.calories.round()} kcal',
                        isHighlighted: true,
                      ),
                      const Divider(),
                      _NutrientRow(
                        label: 'Proteínas',
                        value:
                            '${calculatedValues.macros.protein.toStringAsFixed(1)}g',
                      ),
                      const Divider(),
                      _NutrientRow(
                        label: 'Carbohidratos',
                        value:
                            '${calculatedValues.macros.carbohydrates.toStringAsFixed(1)}g',
                      ),
                      const Divider(),
                      _NutrientRow(
                        label: 'Grasas',
                        value:
                            '${calculatedValues.macros.fats.toStringAsFixed(1)}g',
                      ),
                      const Divider(),
                      _NutrientRow(
                        label: 'Fibra',
                        value:
                            '${calculatedValues.macros.fiber.toStringAsFixed(1)}g',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Add button
              BlocBuilder<FoodLogBloc, FoodLogState>(
                builder: (context, state) {
                  final isLoading = state is FoodLogLogging;
                  return FilledButton(
                    onPressed: isLoading ? null : _logFood,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Agregar al Registro'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMealTypeName(MealType type) {
    switch (type) {
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

class _NutrientRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _NutrientRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight:
                      isHighlighted ? FontWeight.bold : FontWeight.normal,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isHighlighted
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
          ),
        ],
      ),
    );
  }
}
