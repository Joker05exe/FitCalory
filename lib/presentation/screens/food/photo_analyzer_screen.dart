import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/datasources/remote/local_ai_service.dart';
import '../../../domain/entities/food.dart';
import '../../../domain/entities/macronutrients.dart';
import 'food_detail_screen.dart';

class PhotoAnalyzerScreen extends StatefulWidget {
  const PhotoAnalyzerScreen({super.key});

  @override
  State<PhotoAnalyzerScreen> createState() => _PhotoAnalyzerScreenState();
}

class _PhotoAnalyzerScreenState extends State<PhotoAnalyzerScreen> {
  final ImagePicker _picker = ImagePicker();
  final LocalAIService _aiService = LocalAIService();
  XFile? _imageFile;
  bool _isAnalyzing = false;
  String? _errorMessage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageFile = image;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al seleccionar la imagen';
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    try {
      print('🤖 Usando IA Local (Offline y Gratuita)');
      
      // Usar IA local completamente gratuita y offline
      final detectedFood = await _aiService.analyzeFoodImage(_imageFile!.path);
      
      print('IA Local retornó: ${detectedFood != null ? "Alimento detectado: ${detectedFood.name}" : "null"}');

      if (!mounted) return;

      if (detectedFood != null) {
        print('✅ Navegando a FoodDetailScreen con: ${detectedFood.name}');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => FoodDetailScreen(food: detectedFood),
          ),
        );
      } else {
        print('❌ No se detectó alimento');
        setState(() {
          _isAnalyzing = false;
          _errorMessage = 'No se pudo identificar el alimento en la imagen.\nIntenta con una foto más clara.';
        });
      }
    } catch (e, stackTrace) {
      print('❌ Error en _analyzeImage: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = 'Error al analizar la imagen: ${e.toString()}';
        });
      }
    }
  }

  Food _createMockFoodFromImage() {
    // This is a DEMO implementation
    // For REAL AI detection, configure your Gemini API key in:
    // lib/core/config/api_config.dart
    
    // Simulated food database for demo
    final examples = [
      Food(
        id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Tacos',
        brand: 'Detectado por IA (Demo)',
        caloriesPer100g: 226.0,
        macrosPer100g: const Macronutrients(
          protein: 9.0,
          carbohydrates: 26.0,
          fats: 10.0,
          fiber: 3.5,
        ),
        barcode: null,
        servingSizes: const [
          ServingSize(name: '100g', grams: 100, unit: 'g'),
          ServingSize(name: '1 taco', grams: 85, unit: 'g'),
          ServingSize(name: '3 tacos', grams: 255, unit: 'g'),
        ],
        lastUpdated: DateTime.now(),
      ),
      Food(
        id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Plato con brócoli y albóndigas',
        brand: 'Detectado por IA (Demo)',
        caloriesPer100g: 145.0,
        macrosPer100g: const Macronutrients(
          protein: 12.0,
          carbohydrates: 8.0,
          fats: 8.0,
          fiber: 3.0,
        ),
        barcode: null,
        servingSizes: const [
          ServingSize(name: '100g', grams: 100, unit: 'g'),
          ServingSize(name: '1 plato', grams: 350, unit: 'g'),
        ],
        lastUpdated: DateTime.now(),
      ),
      Food(
        id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Ensalada mixta',
        brand: 'Detectado por IA (Demo)',
        caloriesPer100g: 35.0,
        macrosPer100g: const Macronutrients(
          protein: 2.5,
          carbohydrates: 5.0,
          fats: 1.0,
          fiber: 2.0,
        ),
        barcode: null,
        servingSizes: const [
          ServingSize(name: '100g', grams: 100, unit: 'g'),
          ServingSize(name: '1 plato', grams: 200, unit: 'g'),
        ],
        lastUpdated: DateTime.now(),
      ),
      Food(
        id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Pizza',
        brand: 'Detectado por IA (Demo)',
        caloriesPer100g: 266.0,
        macrosPer100g: const Macronutrients(
          protein: 11.0,
          carbohydrates: 33.0,
          fats: 10.0,
          fiber: 2.3,
        ),
        barcode: null,
        servingSizes: const [
          ServingSize(name: '100g', grams: 100, unit: 'g'),
          ServingSize(name: '1 porción', grams: 125, unit: 'g'),
        ],
        lastUpdated: DateTime.now(),
      ),
      Food(
        id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Hamburguesa',
        brand: 'Detectado por IA (Demo)',
        caloriesPer100g: 295.0,
        macrosPer100g: const Macronutrients(
          protein: 17.0,
          carbohydrates: 24.0,
          fats: 14.0,
          fiber: 1.5,
        ),
        barcode: null,
        servingSizes: const [
          ServingSize(name: '100g', grams: 100, unit: 'g'),
          ServingSize(name: '1 hamburguesa', grams: 220, unit: 'g'),
        ],
        lastUpdated: DateTime.now(),
      ),
      Food(
        id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Pasta con salsa',
        brand: 'Detectado por IA (Demo)',
        caloriesPer100g: 131.0,
        macrosPer100g: const Macronutrients(
          protein: 5.0,
          carbohydrates: 25.0,
          fats: 1.3,
          fiber: 1.8,
        ),
        barcode: null,
        servingSizes: const [
          ServingSize(name: '100g', grams: 100, unit: 'g'),
          ServingSize(name: '1 plato', grams: 300, unit: 'g'),
        ],
        lastUpdated: DateTime.now(),
      ),
    ];
    
    // Return a random example for demonstration
    // In real mode with API key, this would be actual AI detection
    return examples[DateTime.now().second % examples.length];
  }

  void _showSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Seleccionar imagen',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de galería'),
              subtitle: const Text('Elegir una foto existente'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              subtitle: const Text('Usar la cámara'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await _pickImage(ImageSource.camera);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cámara no disponible. Usa la galería.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IA Local - Análisis Offline'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              avatar: const Icon(Icons.offline_bolt, size: 16, color: Colors.white),
              label: const Text(
                'GRATIS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _imageFile == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Selecciona una foto de tu comida',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            '🤖 IA Local - Completamente Offline y Gratuita',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            'Analiza colores y patrones para identificar alimentos sin necesidad de internet ni APIs de pago',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green[200]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.offline_bolt,
                                color: Colors.green[700],
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '✅ IA Local Activada',
                                      style: TextStyle(
                                        color: Colors.green[900],
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Sin internet • Sin API • 100% Gratis',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: _showSourceDialog,
                          icon: const Icon(Icons.add_a_photo),
                          label: const Text('Seleccionar foto'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      Center(
                        child: Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (_isAnalyzing)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(height: 16),
                                Text(
                                  'Analizando imagen...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.red[100],
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.red[900],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
          if (_imageFile != null && !_isAnalyzing)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showSourceDialog,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Cambiar foto'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _analyzeImage,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Analizar'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
