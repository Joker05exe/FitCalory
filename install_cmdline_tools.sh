#!/bin/bash

# Script para instalar Android cmdline-tools manualmente

ANDROID_SDK_ROOT="/home/vboxuser/Android/Sdk"
CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
TEMP_DIR="/tmp/cmdline-tools"

echo "Descargando Android cmdline-tools..."
mkdir -p "$TEMP_DIR"
wget -O "$TEMP_DIR/cmdline-tools.zip" "$CMDLINE_TOOLS_URL"

echo "Extrayendo..."
unzip -q "$TEMP_DIR/cmdline-tools.zip" -d "$TEMP_DIR"

echo "Instalando en $ANDROID_SDK_ROOT/cmdline-tools/latest..."
mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"
mv "$TEMP_DIR/cmdline-tools" "$ANDROID_SDK_ROOT/cmdline-tools/latest"

echo "Limpiando archivos temporales..."
rm -rf "$TEMP_DIR"

echo "¡Instalación completada!"
echo "Ahora ejecuta: flutter doctor --android-licenses"
