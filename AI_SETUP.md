# Configuración de IA para Análisis de Fotos

La aplicación utiliza **Google Gemini** para analizar fotos de alimentos y detectar automáticamente su información nutricional.

## 🚀 Cómo activar la IA real

### Paso 1: Obtener API Key de Google Gemini (GRATIS)

1. Ve a [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Inicia sesión con tu cuenta de Google
3. Haz clic en "Create API Key"
4. Copia la API key generada

### Paso 2: Configurar la API Key en la aplicación

1. Abre el archivo `lib/core/config/api_config.dart`
2. Reemplaza `'YOUR_GEMINI_API_KEY_HERE'` con tu API key:

```dart
class ApiConfig {
  static const String geminiApiKey = 'TU_API_KEY_AQUI';
  // ...
}
```

3. Guarda el archivo y reinicia la aplicación

### Paso 3: ¡Listo!

Ahora cuando uses la función "Foto con IA", la aplicación:
- ✅ Analizará la imagen con IA real
- ✅ Detectará el alimento automáticamente
- ✅ Estimará valores nutricionales precisos
- ✅ Mostrará "IA real activada" en verde

## 📝 Notas

- **Gratis**: Google Gemini ofrece 60 requests por minuto gratis
- **Sin tarjeta**: No necesitas tarjeta de crédito
- **Privacidad**: Las imágenes se procesan de forma segura
- **Modo demo**: Si no configuras la API key, la app usará datos simulados

## 🔧 Solución de problemas

### "API key not configured"
- Verifica que hayas reemplazado `YOUR_GEMINI_API_KEY_HERE`
- Asegúrate de guardar el archivo
- Reinicia la aplicación

### "Error al analizar la imagen"
- Verifica tu conexión a internet
- Asegúrate de que la API key sea válida
- Intenta con una foto más clara del alimento

### "Quota exceeded"
- Has superado el límite gratuito (60 requests/minuto)
- Espera un minuto e intenta de nuevo

## 🌟 Características de la IA

La IA de Google Gemini puede detectar:
- 🍎 Frutas y verduras
- 🍕 Comidas preparadas
- 🥗 Ensaladas y platos combinados
- 🍰 Postres y dulces
- 🥤 Bebidas
- Y mucho más...

## 🔐 Seguridad

**IMPORTANTE**: En producción, NO incluyas la API key directamente en el código.

Usa variables de entorno:
```bash
export GEMINI_API_KEY="tu_api_key"
```

O servicios de secretos como:
- Flutter Secure Storage
- AWS Secrets Manager
- Google Cloud Secret Manager
- Azure Key Vault

## 📚 Más información

- [Documentación de Gemini](https://ai.google.dev/docs)
- [Límites y cuotas](https://ai.google.dev/pricing)
- [Mejores prácticas](https://ai.google.dev/docs/best_practices)
