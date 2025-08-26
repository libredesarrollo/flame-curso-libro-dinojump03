# Dimo Jump 03 – Curso Flutter + Flame

Un proyecto de base en Flutter que acompaña el curso “Libro Dinometeor” usando Flame, el motor de juegos para Flutter. Veremos como crear un juego en 2D con saltos, desplazamientos, colisiones, consumibles, daño y más.

Este capítulo empezaremos creando la estructura de un sencillo juego en 2D de colisiones utilizando como base parte del código visto en el capítulo anterior.
Acceso al curso y libro (disponible también en ingles):

https://www.desarrollolibre.net/blog/flutter/flame-desarrollo-de-juegos-en-2d-con-flutter
https://www.desarrollolibre.net/libros/flutter-flame-desarrollo-de-juegos-en-2d
---

##  Descripción

Este repositorio sirve como punto de partida para el curso de desarrollo de videojuegos usando **Flutter** y la librería **Flame**. El proyecto llamado **dinometeor02** presenta una estructura inicial con multiplataforma habilitada (Android, iOS, Web, desktop) y está listo para integrar mecánicas de juego, assets y lógica del curso.

---

##  Características

- Proyecto Flutter generado con soporte para **Android**, **iOS**, **Web**, **Linux**, **macOS**, **Windows** :contentReference[oaicite:1]{index=1}  
- Estructura organizada que incluye carpetas como:
  - `lib/`: código principal en Dart
  - `assets/images`: recursos visuales
  - carpetas específicas por plataforma (`android/`, `ios/`, etc.)

---

##  Contenido actual del README base

El README por defecto incluye:

- Nombre del proyecto: `dinometeor02`  
- Mensaje: *A new Flutter project*  
- Instrucciones para iniciarse en Flutter, con enlaces al lab y cookbook oficiales :contentReference[oaicite:2]{index=2}

---

##  Cómo usar

### Requisitos
- Flutter SDK (versión recomendada: **>= 3.0.0**)
- Dart SDK (incluido en Flutter)

### Instalación
```bash
git clone https://github.com/libredesarrollo/flame-curso-libro-dinometeor-02.git
cd flame-curso-libro-dinometeor-02
flutter pub get
