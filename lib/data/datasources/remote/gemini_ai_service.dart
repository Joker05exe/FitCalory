import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../../../domain/entities/food.dart';
import '../../../domain/entities/macronutrients.dart';

class GeminiAIService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  
  final http.Client client;

  GeminiAIService({http.Client? client}) : client = client ?? http.Client();

  /// Analyze food image using Google Gemini Vision
  Future<Food?> analyzeFoodImage(String imagePath) async {
    if (!ApiConfig.isGeminiConfigured) {
      throw Exception('Gemini API key not configured');
    }
    try {
      // Read image file and convert to base64
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Prepare the prompt for Gemini
      final prompt = '''
Analiza esta imagen de comida y proporciona SOLO un objeto JSON válido con la siguiente estructura:
{
  "name": "nombre específico del alimento en español",
  "caloriesPer100g": número_de_calorías_por_100g,
  "protein": gramos_de_proteína_por_100g,
  "carbohydrates": gramos_de_carbohidratos_por_100g,
  "fats": gramos_de_grasas_por_100g,
  "fiber": gramos_de_fibra_por_100g,
  "servingSize": tamaño_típico_de_porción_en_gramos
}

IMPORTANTE:
- Identifica el alimento principal visible en la imagen
- Usa valores nutricionales reales y precisos
- Si hay múltiples alimentos, describe el plato completo
- Responde ÚNICAMENTE con el JSON, sin texto adicional, sin markdown, sin explicaciones
''';

      // Make API request to Gemini (using gemini-1.5-flash for vision)
      final response = await client.post(
        Uri.parse('$_baseUrl/models/gemini-1.5-flash:generateContent?key=${ApiConfig.geminiApiKey}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image,
                  }
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.4,
            'topK': 32,
            'topP': 1,
            'maxOutputTokens': 2048,
          }
        }),
      );

      print('Gemini API Response Status: ${response.statusCode}');
      print('Gemini API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Extract the generated text
        final candidates = data['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) {
          print('No candidates in response');
          return null;
        }

        final content = candidates[0]['content'];
        final parts = content['parts'] as List;
        final text = parts[0]['text'] as String;

        print('Gemini AI Response Text: $text');

        // Parse the JSON response
        final foodData = _parseGeminiResponse(text);
        
        if (foodData != null) {
          print('Parsed food data: $foodData');
          return _createFoodFromData(foodData);
        } else {
          print('Failed to parse food data from response');
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
      }

      return null;
    } catch (e, stackTrace) {
      print('Error analyzing image with Gemini: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Map<String, dynamic>? _parseGeminiResponse(String text) {
    try {
      // Remove markdown code blocks if present
      String cleanText = text.trim();
      
      // Remove ```json and ``` markers
      if (cleanText.startsWith('```json')) {
        cleanText = cleanText.substring(7);
      } else if (cleanText.startsWith('```')) {
        cleanText = cleanText.substring(3);
      }
      
      if (cleanText.endsWith('```')) {
        cleanText = cleanText.substring(0, cleanText.length - 3);
      }
      
      cleanText = cleanText.trim();

      // Try to find JSON object in the text
      final jsonStart = cleanText.indexOf('{');
      final jsonEnd = cleanText.lastIndexOf('}');
      
      if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
        cleanText = cleanText.substring(jsonStart, jsonEnd + 1);
      }

      print('Attempting to parse JSON: $cleanText');
      final parsed = json.decode(cleanText) as Map<String, dynamic>;
      print('Successfully parsed JSON');
      return parsed;
    } catch (e) {
      print('Error parsing Gemini response: $e');
      print('Text was: $text');
      return null;
    }
  }

  Food _createFoodFromData(Map<String, dynamic> data) {
    final name = data['name'] as String? ?? 'Alimento desconocido';
    final caloriesPer100g = _parseDouble(data['caloriesPer100g']) ?? 0.0;
    final protein = _parseDouble(data['protein']) ?? 0.0;
    final carbs = _parseDouble(data['carbohydrates']) ?? 0.0;
    final fats = _parseDouble(data['fats']) ?? 0.0;
    final fiber = _parseDouble(data['fiber']) ?? 0.0;
    final servingSize = _parseDouble(data['servingSize']) ?? 150.0;

    return Food(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      brand: 'Detectado por IA',
      caloriesPer100g: caloriesPer100g,
      macrosPer100g: Macronutrients(
        protein: protein,
        carbohydrates: carbs,
        fats: fats,
        fiber: fiber,
      ),
      barcode: null,
      servingSizes: [
        const ServingSize(name: '100g', grams: 100, unit: 'g'),
        ServingSize(
          name: 'Porción estimada',
          grams: servingSize,
          unit: 'g',
        ),
      ],
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

  /// Check if API key is configured
  static bool get isConfigured => ApiConfig.isGeminiConfigured;
}
