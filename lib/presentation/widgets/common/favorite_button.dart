import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/food.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';

class FavoriteButton extends StatefulWidget {
  final Food food;
  final double size;
  final bool showBackground;

  const FavoriteButton({
    super.key,
    required this.food,
    this.size = 28,
    this.showBackground = true,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    
    _rotationAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward(from: 0);
    context.read<FavoritesBloc>().add(ToggleFavorite(widget.food));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state is FavoritesLoaded && 
                          state.favoriteIds.contains(widget.food.id);

        return GestureDetector(
          onTap: _onTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Container(
                    width: widget.size + (widget.showBackground ? 16 : 0),
                    height: widget.size + (widget.showBackground ? 16 : 0),
                    decoration: widget.showBackground
                        ? BoxDecoration(
                            gradient: isFavorite
                                ? AppTheme.accentGradient
                                : LinearGradient(
                                    colors: [
                                      Colors.grey[300]!,
                                      Colors.grey[200]!,
                                    ],
                                  ),
                            shape: BoxShape.circle,
                            boxShadow: isFavorite
                                ? [
                                    BoxShadow(
                                      color: AppTheme.accentColor.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          )
                        : null,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.showBackground
                          ? Colors.white
                          : (isFavorite ? AppTheme.accentColor : Colors.grey[400]),
                      size: widget.size,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
