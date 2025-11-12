# Requirements Document

## Introduction

Esta aplicación de seguimiento de calorías es una solución integral para usuarios que desean monitorear su ingesta nutricional, establecer objetivos de salud y fitness, y analizar alimentos mediante tecnología avanzada. La aplicación combina funcionalidades tradicionales de conteo de calorías con capacidades modernas como análisis de imágenes mediante IA y lectura de códigos QR en tiempo real. Desarrollada en Flutter, la aplicación funcionará tanto en dispositivos Android como en PC, proporcionando una experiencia consistente y fluida en ambas plataformas.

## Glossary

- **Sistema**: La aplicación de seguimiento de calorías desarrollada en Flutter
- **Usuario**: Persona que utiliza la aplicación para monitorear su nutrición y objetivos de salud
- **Perfil Nutricional**: Conjunto de datos personales del usuario incluyendo edad, peso, altura, nivel de actividad y objetivos
- **Objetivo de Calorías**: Meta diaria de consumo calórico calculada según el perfil del usuario
- **Registro de Alimento**: Entrada individual que documenta un alimento consumido con sus valores nutricionales
- **Análisis IA**: Proceso de identificación y análisis nutricional de alimentos mediante inteligencia artificial a partir de imágenes
- **Código QR**: Código de barras bidimensional que contiene información nutricional del producto
- **Base de Datos Nutricional**: Repositorio de información nutricional de alimentos y productos
- **Dashboard**: Pantalla principal que muestra el resumen diario de calorías y nutrientes
- **Macronutrientes**: Proteínas, carbohidratos y grasas
- **Historial Nutricional**: Registro histórico de consumo de alimentos y progreso del usuario

## Requirements

### Requirement 1

**User Story:** Como usuario nuevo, quiero crear un perfil personalizado con mis datos físicos y objetivos, para que la aplicación calcule mis necesidades calóricas diarias.

#### Acceptance Criteria

1. WHEN el Usuario inicia la aplicación por primera vez, THE Sistema SHALL mostrar un formulario de registro que solicite nombre, edad, peso, altura, género y nivel de actividad física
2. WHEN el Usuario completa el formulario de registro, THE Sistema SHALL calcular el Objetivo de Calorías diario basado en la fórmula de Harris-Benedict y el nivel de actividad
3. WHEN el Usuario selecciona un objetivo específico (perder peso, mantener peso, ganar masa muscular), THE Sistema SHALL ajustar el Objetivo de Calorías con un déficit o superávit calórico apropiado
4. THE Sistema SHALL almacenar el Perfil Nutricional del Usuario de forma persistente en el dispositivo
5. WHEN el Usuario modifica su Perfil Nutricional, THE Sistema SHALL recalcular automáticamente el Objetivo de Calorías

### Requirement 2

**User Story:** Como usuario, quiero registrar alimentos manualmente mediante búsqueda en una base de datos, para que pueda llevar un seguimiento preciso de mi ingesta diaria.

#### Acceptance Criteria

1. THE Sistema SHALL proporcionar una interfaz de búsqueda de alimentos con autocompletado en tiempo real
2. WHEN el Usuario busca un alimento, THE Sistema SHALL mostrar resultados de la Base de Datos Nutricional con información de calorías y Macronutrientes
3. WHEN el Usuario selecciona un alimento, THE Sistema SHALL permitir especificar la cantidad en gramos, mililitros o porciones estándar
4. WHEN el Usuario confirma un Registro de Alimento, THE Sistema SHALL calcular los valores nutricionales totales basados en la cantidad especificada
5. THE Sistema SHALL agregar el Registro de Alimento al Dashboard del día actual con timestamp de registro

### Requirement 3

**User Story:** Como usuario, quiero escanear códigos QR de productos alimenticios en tiempo real, para que pueda registrar alimentos rápidamente sin búsqueda manual.

#### Acceptance Criteria

1. WHEN el Usuario activa la función de escaneo QR, THE Sistema SHALL acceder a la cámara del dispositivo y mostrar vista previa en tiempo real
2. WHEN el Sistema detecta un Código QR válido en el campo de visión, THE Sistema SHALL decodificar la información del producto automáticamente
3. WHEN el Sistema decodifica un Código QR, THE Sistema SHALL buscar la información nutricional en la Base de Datos Nutricional usando el código del producto
4. IF la información nutricional está disponible, THEN THE Sistema SHALL mostrar los detalles del producto con opción de agregar al registro diario
5. IF la información nutricional no está disponible, THEN THE Sistema SHALL notificar al Usuario y ofrecer la opción de ingreso manual

### Requirement 4

**User Story:** Como usuario, quiero tomar fotografías de mis alimentos y obtener análisis nutricional mediante IA, para que pueda registrar comidas complejas sin esfuerzo manual.

#### Acceptance Criteria

1. WHEN el Usuario activa la función de análisis por foto, THE Sistema SHALL acceder a la cámara del dispositivo y permitir captura de imagen
2. WHEN el Usuario captura una imagen de alimento, THE Sistema SHALL enviar la imagen al servicio de Análisis IA para procesamiento
3. WHEN el Análisis IA procesa la imagen, THE Sistema SHALL identificar los alimentos visibles con un nivel de confianza mínimo del 70 por ciento
4. WHEN el Análisis IA completa el procesamiento, THE Sistema SHALL mostrar los alimentos identificados con estimaciones de porciones y valores nutricionales
5. THE Sistema SHALL permitir al Usuario editar o confirmar los resultados del Análisis IA antes de agregar al registro diario
6. IF el Análisis IA falla o no puede identificar alimentos, THEN THE Sistema SHALL notificar al Usuario y ofrecer opciones alternativas de registro

### Requirement 5

**User Story:** Como usuario, quiero visualizar mi progreso diario y semanal en un dashboard intuitivo, para que pueda monitorear mi adherencia a los objetivos nutricionales.

#### Acceptance Criteria

1. THE Sistema SHALL mostrar en el Dashboard el total de calorías consumidas versus el Objetivo de Calorías del día actual
2. THE Sistema SHALL mostrar en el Dashboard la distribución de Macronutrientes consumidos mediante gráficos visuales
3. WHEN el Usuario accede al Dashboard, THE Sistema SHALL calcular y mostrar las calorías restantes disponibles para el día
4. THE Sistema SHALL proporcionar una vista de Historial Nutricional con gráficos de tendencia semanal y mensual
5. WHEN el Usuario selecciona un día en el Historial Nutricional, THE Sistema SHALL mostrar el detalle completo de Registros de Alimento de ese día

### Requirement 6

**User Story:** Como usuario, quiero establecer y modificar mis objetivos nutricionales personalizados, para que pueda adaptar la aplicación a mis necesidades cambiantes.

#### Acceptance Criteria

1. THE Sistema SHALL permitir al Usuario establecer objetivos personalizados para calorías totales y cada Macronutriente
2. WHEN el Usuario modifica un objetivo, THE Sistema SHALL validar que los valores sean realistas dentro de rangos saludables
3. THE Sistema SHALL proporcionar recomendaciones de distribución de Macronutrientes basadas en el objetivo seleccionado (perder peso, mantener, ganar masa)
4. WHEN el Usuario establece un nuevo objetivo, THE Sistema SHALL aplicar los cambios a partir del día siguiente
5. THE Sistema SHALL mantener un historial de cambios de objetivos para análisis de progreso a largo plazo

### Requirement 7

**User Story:** Como usuario, quiero que la aplicación funcione sin conexión a internet, para que pueda registrar alimentos en cualquier momento y lugar.

#### Acceptance Criteria

1. THE Sistema SHALL almacenar una Base de Datos Nutricional local con alimentos comunes y sus valores nutricionales
2. WHILE el dispositivo no tiene conexión a internet, THE Sistema SHALL permitir búsqueda y registro de alimentos desde la base de datos local
3. WHILE el dispositivo no tiene conexión a internet, THE Sistema SHALL almacenar localmente todos los Registros de Alimento y cambios de perfil
4. WHEN el dispositivo recupera conexión a internet, THE Sistema SHALL sincronizar automáticamente los datos locales con el servidor
5. IF el escaneo QR o Análisis IA requieren conexión, THEN THE Sistema SHALL notificar al Usuario y ofrecer registro manual alternativo

### Requirement 8

**User Story:** Como usuario, quiero recibir notificaciones y recordatorios personalizados, para que pueda mantener consistencia en mi seguimiento nutricional.

#### Acceptance Criteria

1. THE Sistema SHALL permitir al Usuario configurar recordatorios para registrar comidas en horarios específicos
2. WHEN llega la hora de un recordatorio configurado, THE Sistema SHALL enviar una notificación push al dispositivo del Usuario
3. WHEN el Usuario está cerca de alcanzar su Objetivo de Calorías diario, THE Sistema SHALL enviar una notificación de advertencia
4. THE Sistema SHALL permitir al Usuario habilitar o deshabilitar notificaciones individualmente desde la configuración
5. WHEN el Usuario no ha registrado alimentos durante 24 horas, THE Sistema SHALL enviar una notificación de motivación

### Requirement 9

**User Story:** Como usuario, quiero que la aplicación tenga una interfaz consistente y responsiva en PC y Android, para que pueda usar cualquier dispositivo según mi conveniencia.

#### Acceptance Criteria

1. THE Sistema SHALL adaptar la interfaz de usuario automáticamente según el tamaño de pantalla del dispositivo
2. WHEN el Usuario ejecuta la aplicación en PC, THE Sistema SHALL optimizar el layout para pantallas grandes con navegación lateral
3. WHEN el Usuario ejecuta la aplicación en Android, THE Sistema SHALL optimizar el layout para pantallas táctiles con navegación inferior
4. THE Sistema SHALL mantener sincronizados los datos del Usuario entre dispositivos mediante cuenta de usuario
5. THE Sistema SHALL responder a interacciones del Usuario en menos de 300 milisegundos para mantener fluidez

### Requirement 10

**User Story:** Como usuario, quiero evaluar mi progreso mediante métricas y estadísticas detalladas, para que pueda tomar decisiones informadas sobre mi nutrición.

#### Acceptance Criteria

1. THE Sistema SHALL calcular y mostrar el promedio de calorías consumidas en períodos de 7, 30 y 90 días
2. THE Sistema SHALL generar gráficos de tendencia que muestren la evolución del peso del Usuario a lo largo del tiempo
3. WHEN el Usuario accede a las estadísticas, THE Sistema SHALL mostrar el porcentaje de días en que cumplió su Objetivo de Calorías
4. THE Sistema SHALL calcular y mostrar la distribución promedio de Macronutrientes en el período seleccionado
5. THE Sistema SHALL proporcionar insights automáticos sobre patrones de consumo y sugerencias de mejora
