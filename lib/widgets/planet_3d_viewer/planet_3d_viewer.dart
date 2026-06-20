import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:space_solar_app/core/responsive_helper.dart';

/// Widget que reemplaza la imagen estática del planeta por un modelo 3D
/// cargado con flutter_cube, con rotación automática y un botón para
/// alternar entre el modelo "realista" (assets/planetaReal) y el modelo
/// "low poly" (assets/planeta3d).
class Planet3DViewer extends StatefulWidget {
  final int planetIndex;

  const Planet3DViewer({super.key, required this.planetIndex});

  @override
  State<Planet3DViewer> createState() => _Planet3DViewerState();
}

class _Planet3DViewerState extends State<Planet3DViewer>
    with SingleTickerProviderStateMixin {
  // Nombres de archivo (sin extensión), en el MISMO orden que usan
  // planetAssets / nombrePlanetaEsp en detail_planet.dart.
  // Cada carpeta debe contener: nombre.obj, nombre.mtl y la textura
  // que referencia el .mtl (ej: mercurio.obj, mercurio.mtl, mercurio.png)
  static const List<String> _fileNames = [
    'mercurio',
    'venus',
    'tierra',
    'marte',
    'jupiter',
    'saturno',
    'urano',
    'neptuno',
  ];

  bool _isLowPoly = false;
  Scene? _scene;
  Object? _planetObject;
  late AnimationController _rotationController;

  String get _currentObjPath {
    final folder = _isLowPoly ? 'planeta3d' : 'planetaReal';
    return 'assets/$folder/${_fileNames[widget.planetIndex]}.obj';
  }

  @override
  void initState() {
    super.initState();
    // Duración de una vuelta completa (360°). Súbela para una rotación
    // más lenta, bájala para que gire más rápido.
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..addListener(_onRotationTick);
    _rotationController.repeat();
  }

  void _onRotationTick() {
    if (_planetObject != null && _scene != null) {
      _planetObject!.rotation.y = _rotationController.value * 360;
      _planetObject!.updateTransform();
      _scene!.update();
    }
  }

  void _onSceneCreated(Scene scene) {
    _scene = scene;

    // Cámara y luz básicas. Si el planeta se ve muy chico o muy grande
    // según la escala con la que exportaste el .obj desde Blender,
    // ajusta este valor (más alto = la cámara se aleja).
    scene.camera.position.z = 1.2;
    scene.light.position.setFrom(Vector3(2, 2, 5));
    scene.light.setColor(Colors.white, 0.4, 0.8, 0.3);

    final object = Object(
      fileName: _currentObjPath,
      lighting: true,
      backfaceCulling: false,
    );

    scene.world.add(object);
    _planetObject = object;
  }

  void _toggleModel() {
    setState(() {
      _isLowPoly = !_isLowPoly;
      // Al cambiar la key del Cube más abajo, Flutter destruye la escena
      // anterior y vuelve a llamar a _onSceneCreated con el modelo nuevo.
      _scene = null;
      _planetObject = null;
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 1000.w,
          height: 800.h,
          child: Cube(
            // La key incluye el planeta y el modo (real/low poly) para que
            // cada combinación fuerce una escena nueva al cambiar.
            key: ValueKey('${widget.planetIndex}_$_isLowPoly'),
            onSceneCreated: _onSceneCreated,
          ),
        ),
        SizedBox(height: 10.h),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.threed_rotation,
                color: _isLowPoly ? Colors.orange : Colors.white,
                size: 38,
              ),
              tooltip: _isLowPoly
                  ? 'Ver modelo realista'
                  : 'Ver modelo low poly',
              onPressed: _toggleModel,
            ),
            Text(
              _isLowPoly ? 'LOW POLY' : 'MODELO 3D',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white60,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}