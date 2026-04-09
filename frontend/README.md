#  Kinetic News App
Un lector de noticias multiplataforma (Móvil y Web) diseñado con arquitectura limpia (**Clean Architecture**), persistencia local y sincronización con la nube.

### 🌐 Live Web Demo
**¡Pruébala ahora en vivo!**: [https://simetry-app.web.app](https://simetry-app.web.app)

---

## ✨ Características Principales
*   **Soporte Multiplataforma**: Experiencia optimizada para móviles (iOS/Android) y navegadores Web (Chrome).
*   **Diseño Premium**: UI moderna con componentes responsivos, animaciones sutiles y ergonomía web.
*   **Gestión de Artículos**: Crea, edita y gestiona tus propias noticias con subida de imágenes a Cloudinary.
*   **Persistencia Robusta**: Guardado local de datos de perfil y noticias favoritas usando Hive.
*   **Arquitectura Limpia**: Separación estricta de responsabilidades (Data, Domain, Presentation).

## 🛠️ Tecnologías Utilizadas
*   **Framework**: Flutter 3.x
*   **Estado**: BLoC / Cubit
*   **Persistencia**: Hive & Firestore
*   **Imágenes**: Cloudinary API
*   **Despliegue**: Firebase Hosting

---

##  Cómo empezar

1. **Clonar el repositorio**
   ```bash
   git clone <URL_DEL_REPO>
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar el proyecto**
   * **Web**: `flutter run -d chrome`
   * **Móvil**: `flutter run`

---

### 📚 Recursos
Este proyecto está basado en el patrón de arquitectura limpia. Para profundizar en los conceptos, recomendamos consultar: [Flutter Clean Architecture Tutorial](https://www.youtube.com/watch?v=7V_P6dovixg).
