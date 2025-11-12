#!/bin/bash

# Script de ayuda para ejecutar la aplicación Calorie Tracker

echo "🍎 Calorie Tracker - Script de Ejecución"
echo "========================================"
echo ""

# Verificar si Flutter está instalado
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter no está instalado"
    echo "Por favor instala Flutter desde: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter encontrado"
flutter --version
echo ""

# Función para mostrar el menú
show_menu() {
    echo "Selecciona una opción:"
    echo "1) Instalar dependencias (flutter pub get)"
    echo "2) Generar código Hive (build_runner)"
    echo "3) Analizar código (flutter analyze)"
    echo "4) Ejecutar app en modo debug"
    echo "5) Ejecutar app en modo release"
    echo "6) Limpiar proyecto (flutter clean)"
    echo "7) Setup completo (clean + pub get + build_runner)"
    echo "8) Listar dispositivos disponibles"
    echo "9) Salir"
    echo ""
    read -p "Opción: " option
}

# Función para instalar dependencias
install_deps() {
    echo "📦 Instalando dependencias..."
    flutter pub get
    echo ""
}

# Función para generar código
generate_code() {
    echo "🔨 Generando código Hive..."
    flutter pub run build_runner build --delete-conflicting-outputs
    echo ""
}

# Función para analizar código
analyze_code() {
    echo "🔍 Analizando código..."
    flutter analyze
    echo ""
}

# Función para ejecutar en debug
run_debug() {
    echo "🚀 Ejecutando en modo debug..."
    flutter run
}

# Función para ejecutar en release
run_release() {
    echo "🚀 Ejecutando en modo release..."
    flutter run --release
}

# Función para limpiar proyecto
clean_project() {
    echo "🧹 Limpiando proyecto..."
    flutter clean
    echo ""
}

# Función para setup completo
full_setup() {
    echo "🔧 Setup completo..."
    clean_project
    install_deps
    generate_code
    echo "✅ Setup completado!"
    echo ""
}

# Función para listar dispositivos
list_devices() {
    echo "📱 Dispositivos disponibles:"
    flutter devices
    echo ""
}

# Loop principal
while true; do
    show_menu
    
    case $option in
        1)
            install_deps
            ;;
        2)
            generate_code
            ;;
        3)
            analyze_code
            ;;
        4)
            run_debug
            ;;
        5)
            run_release
            ;;
        6)
            clean_project
            ;;
        7)
            full_setup
            ;;
        8)
            list_devices
            ;;
        9)
            echo "👋 ¡Hasta luego!"
            exit 0
            ;;
        *)
            echo "❌ Opción inválida"
            echo ""
            ;;
    esac
done
