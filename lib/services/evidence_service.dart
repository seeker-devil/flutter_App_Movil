import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../local/database/app_database.dart';

enum LocationServiceStatus {
  enabled,
  disabled,
  permissionDenied,
  permissionPermanentlyDenied,
  error,
}

class LocationResult {
  final LocationServiceStatus status;
  final Position? position;
  final String? errorMessage;

  LocationResult({
    required this.status,
    this.position,
    this.errorMessage,
  });
}

class CameraCaptureResult {
  final bool success;
  final String? persistentPath;
  final bool cancelled;
  final String? errorMessage;
  final PermissionStatus permissionStatus;

  CameraCaptureResult({
    required this.success,
    this.persistentPath,
    this.cancelled = false,
    this.errorMessage,
    required this.permissionStatus,
  });
}

class EvidenceService {
  final AppDatabase db;
  final ImagePicker _picker;

  EvidenceService({
    required this.db,
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();

  /// Check Camera permission status
  Future<PermissionStatus> checkCameraPermission() async {
    return await Permission.camera.status;
  }

  /// Request Camera permission with optional rationale context dialog
  Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  /// Capture photo using camera and save permanently in app's private documents directory
  Future<CameraCaptureResult> capturePhotoWithCamera(BuildContext context) async {
    var status = await Permission.camera.status;

    // 1. If not determined/denied initially, ask rationale then request
    if (status.isDenied) {
      if (!context.mounted) {
        return CameraCaptureResult(
          success: false,
          permissionStatus: status,
          errorMessage: 'Navegación cancelada.',
        );
      }
      final proceed = await showRationaleDialog(
        context,
        title: 'Permiso de Cámara Requerido',
        message:
            'SafeAccess 90 necesita acceso a la cámara para tomar una fotografía de la evidencia de seguridad observada en campo. La fotografía es opcional.',
      );
      if (!proceed) {
        return CameraCaptureResult(
          success: false,
          permissionStatus: status,
          errorMessage: 'Solicitud cancelada por el usuario.',
        );
      }
      status = await Permission.camera.request();
    }

    // 2. Handle permanently denied
    if (status.isPermanentlyDenied) {
      return CameraCaptureResult(
        success: false,
        permissionStatus: status,
        errorMessage:
            'El permiso de cámara fue denegado permanentemente en los ajustes del sistema.',
      );
    }

    if (!status.isGranted) {
      return CameraCaptureResult(
        success: false,
        permissionStatus: status,
        errorMessage: 'Permiso de cámara no concedido.',
      );
    }

    // 3. Attempt camera capture
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1280,
        maxHeight: 1280,
      );

      if (photo == null) {
        // User cancelled camera capture
        return CameraCaptureResult(
          success: false,
          cancelled: true,
          permissionStatus: status,
        );
      }

      // 4. Save to private persistent app documents directory (not temp cache)
      final appDocDir = await getApplicationDocumentsDirectory();
      final evidencesFolder = Directory(path.join(appDocDir.path, 'evidences'));
      if (!await evidencesFolder.exists()) {
        await evidencesFolder.create(recursive: true);
      }

      final fileName = '${const Uuid().v4()}.jpg';
      final savedPath = path.join(evidencesFolder.path, fileName);
      final savedFile = await File(photo.path).copy(savedPath);

      return CameraCaptureResult(
        success: true,
        persistentPath: savedFile.path,
        permissionStatus: status,
      );
    } catch (e) {
      return CameraCaptureResult(
        success: false,
        errorMessage: 'Error al capturar imagen: $e',
        permissionStatus: status,
      );
    }
  }

  /// Check location service & permission state, and acquire position on-demand
  Future<LocationResult> getCurrentLocation(BuildContext context) async {
    // 1. Check if GPS / Location services are enabled on device
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult(
        status: LocationServiceStatus.disabled,
        errorMessage:
            'El servicio de ubicación (GPS) está desactivado en el dispositivo.',
      );
    }

    // 2. Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (!context.mounted) {
        return LocationResult(
          status: LocationServiceStatus.permissionDenied,
          errorMessage: 'Navegación cancelada.',
        );
      }
      final proceed = await showRationaleDialog(
        context,
        title: 'Permiso de Ubicación Requerido',
        message:
            'SafeAccess 90 necesita acceder a su ubicación durante el uso para georreferenciar la evidencia de seguridad. La ubicación es opcional.',
      );
      if (!proceed) {
        return LocationResult(
          status: LocationServiceStatus.permissionDenied,
          errorMessage: 'Solicitud de ubicación cancelada.',
        );
      }
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return LocationResult(
        status: LocationServiceStatus.permissionDenied,
        errorMessage: 'Permiso de ubicación denegado por el usuario.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult(
        status: LocationServiceStatus.permissionPermanentlyDenied,
        errorMessage:
            'El permiso de ubicación fue denegado permanentemente. Abra los ajustes para activarlo.',
      );
    }

    // 3. Get current position with timeout handling
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return LocationResult(
        status: LocationServiceStatus.enabled,
        position: position,
      );
    } catch (e) {
      return LocationResult(
        status: LocationServiceStatus.error,
        errorMessage: 'Falló la obtención de coordenadas GPS: $e',
      );
    }
  }

  /// Open application settings screen when permanently denied
  Future<void> openAppSettingsScreen() async {
    await openAppSettings();
  }

  /// Save safety observation evidence in local Drift SQLite and enqueue for sync
  Future<LocalEvidence> createLocalEvidence({
    required String description,
    String? imagePath,
    double? latitude,
    double? longitude,
  }) async {
    final clientId = const Uuid().v4();
    final now = DateTime.now();

    // 1. Save to local Drift EvidencesTable
    await db.saveEvidence(
      EvidencesTableCompanion.insert(
        clientId: clientId,
        description: description,
        imagePath: drift.Value(imagePath),
        latitude: drift.Value(latitude),
        longitude: drift.Value(longitude),
        capturedAt: now,
        syncStatus: const drift.Value('PENDING'),
        createdAtLocal: now,
        updatedAtLocal: now,
      ),
    );

    // 2. Enqueue into PendingOperationsTable
    final payloadMap = {
      'description': description,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'capturedAt': now.toIso8601String(),
    };

    await db.enqueuePendingOperation(
      PendingOperationsTableCompanion.insert(
        clientId: clientId,
        entityType: 'EVIDENCE',
        operationType: 'CREATE',
        payload: Uri.encodeFull(payloadMap.toString()),
        createdAt: now,
        status: const drift.Value('PENDING'),
      ),
    );

    return (await db.getEvidenceByClientId(clientId))!;
  }

  /// Rationale Explanation Dialog before requesting permission
  static Future<bool> showRationaleDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar / Continuar sin permiso'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Conceder permiso'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
