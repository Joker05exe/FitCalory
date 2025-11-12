#!/bin/bash

echo "=== Compilando APK de Calorie Tracker ==="

# Configurar Java 17
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

echo "Java version:"
java -version

echo ""
echo "=== Limpiando proyecto ==="
flutter clean

echo ""
echo "=== Obteniendo dependencias ==="
flutter pub get

echo ""
echo "=== Compilando APK (esto puede tardar varios minutos) ==="
cd android
./gradlew assembleRelease --no-daemon --stacktrace --info 2>&1 | tee ../gradle_build.log

echo ""
echo "=== Verificando APK generado ==="
cd ..
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✓ APK generado exitosamente!"
    ls -lh build/app/outputs/flutter-apk/app-release.apk
else
    echo "✗ Error: No se pudo generar el APK"
    echo "Revisa el archivo gradle_build.log para más detalles"
    exit 1
fi
