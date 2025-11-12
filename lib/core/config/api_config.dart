/// API Configuration
/// 
/// Para usar la IA real con Google Gemini:
/// 1. Obtén tu API key gratis en: https://aistudio.google.com/app/apikey
/// 2. Reemplaza 'YOUR_GEMINI_API_KEY_HERE' con tu API key
/// 3. Reinicia la aplicación
/// 
/// Nota: En producción, usa variables de entorno o un servicio de secretos

class ApiConfig {
  // Google Gemini API Key
  // Obtén tu key gratis en: https://aistudio.google.com/app/apikey
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  
  /// Check if Gemini API is configured
  static bool get isGeminiConfigured => geminiApiKey != 'YOUR_GEMINI_API_KEY_HERE';
  
  // OpenFoodFacts no requiere API key (es público)
  static const String openFoodFactsUserAgent = 'CalorieTracker - Flutter App - Version 1.0';
}
