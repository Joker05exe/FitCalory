import 'package:flutter/material.dart';
import '../../../domain/entities/food.dart';
import '../../../core/theme/app_theme.dart';

class FavoriteFoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback onRemove;

  const FavoriteFoodCard({
    super.key,
    required this.food,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppTheme.primaryColor.withOpacity(0.02),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to food detail
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfo(context),
                ),
                _buildFavoriteButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.restaurant,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          food.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (food.brand != null) ...[
          const SizedBox(height: 4),
          Text(
            food.brand!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            _buildNutrientChip(
              '${food.caloriesPer100g.toInt()} kcal',
              AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            _buildNutrientChip(
              'P: ${food.macrosPer100g.protein.toInt()}g',
              AppTheme.secondaryColor,
            ),
            const SizedBox(width: 8),
            _buildNutrientChip(
              'C: ${food.macrosPer100g.carbohydrates.toInt()}g',
              AppTheme.warningColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return IconButton(
      onPressed: onRemove,
      icon: const Icon(Icons.favorite),
      color: AppTheme.accentColor,
      iconSize: 28,
    );
  }
}
