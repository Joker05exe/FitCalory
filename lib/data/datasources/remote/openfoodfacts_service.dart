import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/entities/food.dart';
import '../../../domain/entities/macronutrients.dart';

class OpenFoodFactsService {
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v2';
  final http.Client client;

  OpenFoodFactsService({http.Client? client}) : client = client ?? http.Client();

  /// Search products by text query
  Future<List<Food>> searchProducts(String query, {int page = 1, int pageSize = 25}) async {
    try {
      print('🔍 Buscando en OpenFoodFacts: "$query"');
      
      // Usar el endpoint correcto de búsqueda con CGI
      final url = 'https://world.openfoodfacts.org/cgi/search.pl?'
          'search_terms=$query&'
          'page=$page&'
          'page_size=$pageSize&'
          'action=process&'
          'json=1&'
          'fields=code,product_name,product_name_es,brands,nutriments,serving_quantity';
      
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'CalorieTracker - Flutter App - Version 1.0',
        },
      );

      print('📡 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = data['products'] as List? ?? [];
        
        print('📦 Productos recibidos: ${products.length}');
        
        // Filtrar productos con nutrientes válidos
        final results = products
            .where((p) {
              final nutriments = p['nutriments'];
              if (nutriments == null) return false;
              
              // Debe tener al menos calorías
              final hasCalories = nutriments['energy-kcal_100g'] != null || 
                                 nutriments['energy_100g'] != null;
              return hasCalories;
            })
            .map((product) {
              try {
                final barcode = product['code']?.toString() ?? '';
                final food = _parseProduct(product, barcode);
                print('✅ ${food.name} - ${food.caloriesPer100g.toInt()} kcal');
                return food;
              } catch (e) {
                print('❌ Error parsing: $e');
                return null;
              }
            })
            .whereType<Food>()
            .toList();
        
        print('🎯 Resultados finales: ${results.length}');
        return results;
      }
      
      print('❌ Error: Status code ${response.statusCode}');
      return [];
    } catch (e) {
      print('❌ Error searching: $e');
      return [];
    }
  }

  /// Get product by barcode from OpenFoodFacts
  Future<Food?> getProductByBarcode(String barcode) async {
    try {
      final response = await client.get(
        Uri.parse('$_baseUrl/product/$barcode.json'),
        headers: {
          'User-Agent': 'CalorieTracker - Flutter App - Version 1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 1 && data['product'] != null) {
          return _parseProduct(data['product'], barcode);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching product from OpenFoodFacts: $e');
      return null;
    }
  }

  Food _parseProduct(Map<String, dynamic> product, String barcode) {
    // Get nutriments
    final nutriments = product['nutriments'] ?? {};
    
    // Extract nutritional values per 100g
    final caloriesPer100g = _parseDouble(nutriments['energy-kcal_100g']) ?? 
                           _parseDouble(nutriments['energy_100g']) ?? 0.0;
    final proteinPer100g = _parseDouble(nutriments['proteins_100g']) ?? 0.0;
    final carbsPer100g = _parseDouble(nutriments['carbohydrates_100g']) ?? 0.0;
    final fatsPer100g = _parseDouble(nutriments['fat_100g']) ?? 0.0;
    final fiberPer100g = _parseDouble(nutriments['fiber_100g']) ?? 0.0;

    // Get product name - priorizar español
    String productName = 'Producto sin nombre';
    if (product['product_name_es'] != null && product['product_name_es'].toString().isNotEmpty) {
      productName = product['product_name_es'];
    } else if (product['product_name'] != null && product['product_name'].toString().isNotEmpty) {
      productName = product['product_name'];
    } else if (product['product_name_en'] != null && product['product_name_en'].toString().isNotEmpty) {
      productName = product['product_name_en'];
    }

    // Get brand
    final brand = product['brands']?.toString() ?? '';

    // Create serving sizes
    final servingSizes = <ServingSize>[];
    
    // Add 100g as default
    servingSizes.add(const ServingSize(
      name: '100g',
      grams: 100,
      unit: 'g',
    ));

    // Add serving size if available
    final servingSize = _parseDouble(product['serving_quantity']);
    if (servingSize != null && servingSize > 0) {
      servingSizes.add(ServingSize(
        name: 'Porción',
        grams: servingSize,
        unit: 'g',
      ));
    }

    return Food(
      id: 'off_$barcode',
      name: productName,
      brand: brand.isNotEmpty ? brand : null,
      caloriesPer100g: caloriesPer100g,
      macrosPer100g: Macronutrients(
        protein: proteinPer100g,
        carbohydrates: carbsPer100g,
        fats: fatsPer100g,
        fiber: fiberPer100g,
      ),
      barcode: barcode,
      servingSizes: servingSizes,
      lastUpdated: DateTime.now(),
    );
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
