import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../../../domain/entities/food.dart';
import '../../../domain/entities/macronutrients.dart';

/// Servicio de IA local completamente gratuito y offline
/// Usa un sistema de reconocimiento de patrones simple sin necesidad de APIs externas
class LocalAIService {
  // Base de datos de alimentos comunes con sus valores nutricionales
  static final Map<String, Map<String, dynamic>> _foodDatabase = {
    'manzana': {
      'caloriesPer100g': 52.0,
      'protein': 0.3,
      'carbohydrates': 14.0,
      'fats': 0.2,
      'fiber': 2.4,
      'servingSize': 150.0,
    },
    'plátano': {
      'caloriesPer100g': 89.0,
      'protein': 1.1,
      'carbohydrates': 23.0,
      'fats': 0.3,
      'fiber': 2.6,
      'servingSize': 120.0,
    },
    'banana': {
      'caloriesPer100g': 89.0,
      'protein': 1.1,
      'carbohydrates': 23.0,
      'fats': 0.3,
      'fiber': 2.6,
      'servingSize': 120.0,
    },
    'naranja': {
      'caloriesPer100g': 47.0,
      'protein': 0.9,
      'carbohydrates': 12.0,
      'fats': 0.1,
      'fiber': 2.4,
      'servingSize': 130.0,
    },
    'pollo': {
      'caloriesPer100g': 165.0,
      'protein': 31.0,
      'carbohydrates': 0.0,
      'fats': 3.6,
      'fiber': 0.0,
      'servingSize': 150.0,
    },
    'arroz': {
      'caloriesPer100g': 130.0,
      'protein': 2.7,
      'carbohydrates': 28.0,
      'fats': 0.3,
      'fiber': 0.4,
      'servingSize': 150.0,
    },
    'pasta': {
      'caloriesPer100g': 131.0,
      'protein': 5.0,
      'carbohydrates': 25.0,
      'fats': 1.1,
      'fiber': 1.8,
      'servingSize': 200.0,
    },
    'pan': {
      'caloriesPer100g': 265.0,
      'protein': 9.0,
      'carbohydrates': 49.0,
      'fats': 3.2,
      'fiber': 2.7,
      'servingSize': 60.0,
    },
    'huevo': {
      'caloriesPer100g': 155.0,
      'protein': 13.0,
      'carbohydrates': 1.1,
      'fats': 11.0,
      'fiber': 0.0,
      'servingSize': 50.0,
    },
    'leche': {
      'caloriesPer100g': 42.0,
      'protein': 3.4,
      'carbohydrates': 5.0,
      'fats': 1.0,
      'fiber': 0.0,
      'servingSize': 250.0,
    },
    'yogur': {
      'caloriesPer100g': 59.0,
      'protein': 3.5,
      'carbohydrates': 4.7,
      'fats': 3.3,
      'fiber': 0.0,
      'servingSize': 125.0,
    },
    'queso': {
      'caloriesPer100g': 402.0,
      'protein': 25.0,
      'carbohydrates': 1.3,
      'fats': 33.0,
      'fiber': 0.0,
      'servingSize': 30.0,
    },
    'tomate': {
      'caloriesPer100g': 18.0,
      'protein': 0.9,
      'carbohydrates': 3.9,
      'fats': 0.2,
      'fiber': 1.2,
      'servingSize': 100.0,
    },
    'lechuga': {
      'caloriesPer100g': 15.0,
      'protein': 1.4,
      'carbohydrates': 2.9,
      'fats': 0.2,
      'fiber': 1.3,
      'servingSize': 80.0,
    },
    'zanahoria': {
      'caloriesPer100g': 41.0,
      'protein': 0.9,
      'carbohydrates': 10.0,
      'fats': 0.2,
      'fiber': 2.8,
      'servingSize': 80.0,
    },
    'patata': {
      'caloriesPer100g': 77.0,
      'protein': 2.0,
      'carbohydrates': 17.0,
      'fats': 0.1,
      'fiber': 2.2,
      'servingSize': 150.0,
    },
    'carne': {
      'caloriesPer100g': 250.0,
      'protein': 26.0,
      'carbohydrates': 0.0,
      'fats': 17.0,
      'fiber': 0.0,
      'servingSize': 150.0,
    },
    'pescado': {
      'caloriesPer100g': 206.0,
      'protein': 22.0,
      'carbohydrates': 0.0,
      'fats': 12.0,
      'fiber': 0.0,
      'servingSize': 150.0,
    },
    'ensalada': {
      'caloriesPer100g': 25.0,
      'protein': 1.5,
      'carbohydrates': 5.0,
      'fats': 0.3,
      'fiber': 2.0,
      'servingSize': 200.0,
    },
    'pizza': {
      'caloriesPer100g': 266.0,
      'protein': 11.0,
      'carbohydrates': 33.0,
      'fats': 10.0,
      'fiber': 2.3,
      'servingSize': 200.0,
    },
    'hamburguesa': {
      'caloriesPer100g': 295.0,
      'protein': 17.0,
      'carbohydrates': 24.0,
      'fats': 14.0,
      'fiber': 1.5,
      'servingSize': 200.0,
    },
    'sandwich': {
      'caloriesPer100g': 250.0,
      'protein': 12.0,
      'carbohydrates': 30.0,
      'fats': 8.0,
      'fiber': 2.0,
      'servingSize': 150.0,
    },
    'ensalada mixta': {
      'caloriesPer100g': 35.0,
      'protein': 2.0,
      'carbohydrates': 6.0,
      'fats': 0.5,
      'fiber': 2.5,
      'servingSize': 200.0,
    },
    'salmón': {
      'caloriesPer100g': 208.0,
      'protein': 20.0,
      'carbohydrates': 0.0,
      'fats': 13.0,
      'fiber': 0.0,
      'servingSize': 150.0,
    },
    'atún': {
      'caloriesPer100g': 144.0,
      'protein': 30.0,
      'carbohydrates': 0.0,
      'fats': 1.0,
      'fiber': 0.0,
      'servingSize': 150.0,
    },
    'brócoli': {
      'caloriesPer100g': 34.0,
      'protein': 2.8,
      'carbohydrates': 7.0,
      'fats': 0.4,
      'fiber': 2.6,
      'servingSize': 100.0,
    },
    'espinacas': {
      'caloriesPer100g': 23.0,
      'protein': 2.9,
      'carbohydrates': 3.6,
      'fats': 0.4,
      'fiber': 2.2,
      'servingSize': 100.0,
    },
    'aguacate': {
      'caloriesPer100g': 160.0,
      'protein': 2.0,
      'carbohydrates': 9.0,
      'fats': 15.0,
      'fiber': 7.0,
      'servingSize': 100.0,
    },
    'fresas': {
      'caloriesPer100g': 32.0,
      'protein': 0.7,
      'carbohydrates': 8.0,
      'fats': 0.3,
      'fiber': 2.0,
      'servingSize': 150.0,
    },
    'uvas': {
      'caloriesPer100g': 69.0,
      'protein': 0.7,
      'carbohydrates': 18.0,
      'fats': 0.2,
      'fiber': 0.9,
      'servingSize': 100.0,
    },
  };

  /// Analiza una imagen de comida usando análisis de color y patrones
  /// Completamente offline y gratuito
  Future<Food?> analyzeFoodImage(String imagePath) async {
    try {
      print('🤖 Analizando imagen con IA local (offline y gratuito)...');
      
      // Leer la imagen
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        print('❌ No se pudo decodificar la imagen');
        return null;
      }

      print('✅ Imagen cargada: ${image.width}x${image.height}');

      // Analizar colores dominantes de la imagen
      final colorAnalysis = _analyzeImageColors(image);
      print('🎨 Análisis de colores: $colorAnalysis');

      // Determinar el tipo de alimento basado en colores
      final foodName = _determineFoodFromColors(colorAnalysis);
      print('🍽️ Alimento detectado: $foodName');

      // Obtener datos nutricionales de la base de datos (búsqueda flexible)
      final foodData = _findFoodData(foodName);

      return _createFoodFromData(foodName, foodData);
    } catch (e, stackTrace) {
      print('❌ Error analizando imagen: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Analiza los colores dominantes de la imagen con algoritmo mejorado
  Map<String, dynamic> _analyzeImageColors(img.Image image) {
    // Análisis de histograma de colores
    Map<String, int> colorHistogram = {
      'red': 0,
      'orange': 0,
      'yellow': 0,
      'green': 0,
      'blue': 0,
      'brown': 0,
      'white': 0,
      'black': 0,
      'beige': 0,
    };

    int totalPixels = 0;
    double avgRed = 0, avgGreen = 0, avgBlue = 0;
    double avgSaturation = 0;

    // Analizar centro de la imagen (donde suele estar el alimento)
    final centerX = image.width ~/ 2;
    final centerY = image.height ~/ 2;
    final radius = (image.width < image.height ? image.width : image.height) ~/ 3;

    for (int y = centerY - radius; y < centerY + radius; y += 5) {
      for (int x = centerX - radius; x < centerX + radius; x += 5) {
        if (x < 0 || x >= image.width || y < 0 || y >= image.height) continue;

        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        avgRed += r;
        avgGreen += g;
        avgBlue += b;

        // Calcular saturación
        final max = [r, g, b].reduce((a, b) => a > b ? a : b);
        final min = [r, g, b].reduce((a, b) => a < b ? a : b);
        final saturation = max == 0 ? 0.0 : (max - min) / max.toDouble();
        avgSaturation += saturation;

        // Clasificar color
        final colorCategory = _classifyPixelColor(r, g, b, saturation);
        colorHistogram[colorCategory] = (colorHistogram[colorCategory] ?? 0) + 1;
        totalPixels++;
      }
    }

    if (totalPixels == 0) totalPixels = 1;

    avgRed /= totalPixels;
    avgGreen /= totalPixels;
    avgBlue /= totalPixels;
    avgSaturation /= totalPixels;

    // Normalizar histograma
    Map<String, double> normalizedHistogram = {};
    colorHistogram.forEach((color, count) {
      normalizedHistogram[color] = count / totalPixels;
    });

    return {
      'histogram': normalizedHistogram,
      'avgRed': avgRed / 255,
      'avgGreen': avgGreen / 255,
      'avgBlue': avgBlue / 255,
      'avgSaturation': avgSaturation,
      'brightness': (avgRed + avgGreen + avgBlue) / (3 * 255),
    };
  }

  /// Clasifica un píxel en una categoría de color
  String _classifyPixelColor(int r, int g, int b, double saturation) {
    final brightness = (r + g + b) / 3;

    // Blanco/Negro
    if (saturation < 0.15) {
      if (brightness > 200) return 'white';
      if (brightness < 50) return 'black';
      return 'beige';
    }

    // Colores saturados
    if (r > g && r > b) {
      if (g > 100 && b < 100) return 'orange';
      return 'red';
    } else if (g > r && g > b) {
      if (r > 100) return 'yellow';
      return 'green';
    } else if (b > r && b > g) {
      return 'blue';
    } else if (r > 100 && g > 80 && b < 80) {
      return 'brown';
    } else if (r > 150 && g > 120 && b < 100) {
      return 'beige';
    }

    return 'beige';
  }

  /// Determina el tipo de alimento basado en análisis avanzado de colores con scoring
  String _determineFoodFromColors(Map<String, dynamic> analysis) {
    final histogram = analysis['histogram'] as Map<String, double>;
    final brightness = analysis['brightness'] as double;
    final saturation = analysis['avgSaturation'] as double;
    final avgRed = analysis['avgRed'] as double;
    final avgGreen = analysis['avgGreen'] as double;
    final avgBlue = analysis['avgBlue'] as double;

    // Encontrar colores dominantes
    List<MapEntry<String, double>> dominantColors = histogram.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final primaryColor = dominantColors.first.key;
    final secondaryColor = dominantColors.length > 1 ? dominantColors[1].key : primaryColor;
    final tertiaryColor = dominantColors.length > 2 ? dominantColors[2].key : secondaryColor;

    print('🎨 Colores: 1º $primaryColor (${(dominantColors.first.value * 100).toInt()}%), 2º $secondaryColor');
    print('💡 RGB: R:${(avgRed * 100).toInt()}% G:${(avgGreen * 100).toInt()}% B:${(avgBlue * 100).toInt()}%');
    print('💡 Brillo: ${(brightness * 100).toInt()}%, Saturación: ${(saturation * 100).toInt()}%');

    // Sistema de scoring para cada alimento
    Map<String, double> scores = {};

    // Frutas rojas/naranjas
    if (primaryColor == 'red' && saturation > 0.4) {
      scores['Tomate'] = 0.8;
      scores['Fresas'] = 0.6;
    }
    if (primaryColor == 'orange') {
      scores['Naranja'] = brightness > 0.5 ? 0.9 : 0.7;
      scores['Zanahoria'] = brightness < 0.5 ? 0.8 : 0.5;
    }

    // Frutas amarillas
    if (primaryColor == 'yellow' || (avgRed > 0.6 && avgGreen > 0.6 && avgBlue < 0.4)) {
      scores['Plátano'] = 0.9;
      scores['Huevo'] = secondaryColor == 'white' ? 0.7 : 0.3;
    }

    // Vegetales verdes
    if (primaryColor == 'green') {
      scores['Lechuga'] = saturation > 0.3 ? 0.8 : 0.6;
      scores['Brócoli'] = saturation > 0.4 ? 0.7 : 0.4;
      scores['Espinacas'] = saturation > 0.35 ? 0.7 : 0.5;
      scores['Ensalada'] = secondaryColor == 'white' || secondaryColor == 'red' ? 0.8 : 0.5;
      scores['Aguacate'] = brightness < 0.4 ? 0.6 : 0.3;
    }

    // Carnes y proteínas
    if (primaryColor == 'brown' || (primaryColor == 'red' && saturation < 0.4)) {
      scores['Carne'] = brightness < 0.45 ? 0.8 : 0.6;
      scores['Pollo'] = (secondaryColor == 'beige' || secondaryColor == 'white') ? 0.7 : 0.4;
      scores['Hamburguesa'] = (secondaryColor == 'green' || tertiaryColor == 'yellow') ? 0.7 : 0.4;
    }

    // Pescados
    if ((primaryColor == 'beige' || primaryColor == 'orange') && brightness > 0.4) {
      scores['Salmón'] = primaryColor == 'orange' ? 0.8 : 0.5;
      scores['Pescado'] = 0.6;
    }

    // Carbohidratos blancos/beige
    if (primaryColor == 'white' || primaryColor == 'beige') {
      scores['Arroz'] = brightness > 0.7 ? 0.8 : 0.5;
      scores['Pasta'] = (secondaryColor == 'yellow' || brightness > 0.6) ? 0.7 : 0.5;
      scores['Pan'] = (primaryColor == 'beige' && brightness < 0.6) ? 0.8 : 0.5;
      scores['Patata'] = (primaryColor == 'beige' && brightness < 0.55) ? 0.7 : 0.4;
      scores['Queso'] = brightness > 0.65 ? 0.6 : 0.4;
    }

    // Platos combinados
    if (dominantColors.length >= 3) {
      final hasRed = histogram['red']! > 0.15;
      final hasYellow = histogram['yellow']! > 0.15;
      final hasBrown = histogram['brown']! > 0.15;
      final hasGreen = histogram['green']! > 0.15;

      if (hasRed && hasYellow) scores['Pizza'] = 0.8;
      if (hasBrown && hasGreen) scores['Hamburguesa'] = 0.75;
      if (hasGreen && (hasRed || histogram['red']! > 0.1)) scores['Ensalada'] = 0.8;
      if ((hasBrown || histogram['brown']! > 0.1) && hasYellow) scores['Sandwich'] = 0.7;
    }

    // Lácteos
    if (primaryColor == 'white' && brightness > 0.75) {
      scores['Leche'] = 0.6;
      scores['Yogur'] = 0.6;
    }

    // Seleccionar el alimento con mayor score
    if (scores.isNotEmpty) {
      final bestMatch = scores.entries.reduce((a, b) => a.value > b.value ? a : b);
      print('🏆 Mejor coincidencia: ${bestMatch.key} (score: ${(bestMatch.value * 100).toInt()}%)');
      
      // Solo retornar si el score es razonable
      if (bestMatch.value > 0.4) {
        return bestMatch.key;
      }
    }

    // Fallback basado en color dominante
    print('⚠️ Usando fallback por color dominante');
    final fallbackMap = {
      'red': 'Tomate',
      'orange': 'Naranja',
      'yellow': 'Plátano',
      'green': 'Ensalada',
      'brown': 'Carne',
      'beige': 'Pollo',
      'white': 'Arroz',
    };

    return fallbackMap[primaryColor] ?? 'Ensalada Mixta';
  }

  /// Busca datos de alimento con búsqueda flexible
  Map<String, dynamic> _findFoodData(String foodName) {
    final searchName = foodName.toLowerCase();
    
    // Búsqueda exacta
    if (_foodDatabase.containsKey(searchName)) {
      return _foodDatabase[searchName]!;
    }

    // Búsqueda parcial
    for (var entry in _foodDatabase.entries) {
      if (entry.key.contains(searchName) || searchName.contains(entry.key)) {
        print('✅ Encontrado por búsqueda parcial: ${entry.key}');
        return entry.value;
      }
    }

    // Por defecto
    print('⚠️ Alimento no encontrado en BD, usando valores por defecto');
    return _getDefaultFoodData();
  }

  /// Obtiene datos nutricionales por defecto
  Map<String, dynamic> _getDefaultFoodData() {
    return {
      'caloriesPer100g': 150.0,
      'protein': 5.0,
      'carbohydrates': 20.0,
      'fats': 5.0,
      'fiber': 2.0,
      'servingSize': 150.0,
    };
  }

  /// Crea un objeto Food a partir de los datos
  Food _createFoodFromData(String name, Map<String, dynamic> data) {
    return Food(
      id: 'local_ai_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      brand: 'Detectado por IA Local (Offline)',
      caloriesPer100g: data['caloriesPer100g'] as double,
      macrosPer100g: Macronutrients(
        protein: data['protein'] as double,
        carbohydrates: data['carbohydrates'] as double,
        fats: data['fats'] as double,
        fiber: data['fiber'] as double,
      ),
      barcode: null,
      servingSizes: [
        const ServingSize(name: '100g', grams: 100, unit: 'g'),
        ServingSize(
          name: 'Porción estimada',
          grams: data['servingSize'] as double,
          unit: 'g',
        ),
      ],
      lastUpdated: DateTime.now(),
    );
  }

  /// Verifica si el servicio está disponible (siempre true porque es local)
  static bool get isAvailable => true;
}
