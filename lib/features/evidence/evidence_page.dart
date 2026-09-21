import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../design_system/components/safe_access_button.dart';
import '../../design_system/components/safe_access_section_card.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import '../../providers/app_providers.dart';
import '../../services/evidence_service.dart';
import '../../shared/app_scaffold.dart';

class EvidencePage extends ConsumerStatefulWidget {
  const EvidencePage({super.key});

  @override
  ConsumerState<EvidencePage> createState() => _EvidencePageState();
}

class _EvidencePageState extends ConsumerState<EvidencePage>
    with WidgetsBindingObserver {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _capturedImagePath;
  Position? _capturedPosition;

  bool _isCapturingCamera = false;
  bool _isFetchingLocation = false;
  bool _isSaving = false;
  bool _isSyncing = false;

  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;
  LocationServiceStatus _locationStatus = LocationServiceStatus.disabled;
  String? _statusBannerMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialPermissionStates();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _descriptionController.dispose();
    super.dispose();
  }

  /// Re-check permission states when user returns to app from System Settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkInitialPermissionStates();
    }
  }

  Future<void> _checkInitialPermissionStates() async {
    final service = ref.read(evidenceServiceProvider);
    final camStatus = await service.checkCameraPermission();
    final isGpsOn = await Geolocator.isLocationServiceEnabled();
    final locPerm = await Geolocator.checkPermission();

    if (mounted) {
      setState(() {
        _cameraPermissionStatus = camStatus;
        if (!isGpsOn) {
          _locationStatus = LocationServiceStatus.disabled;
        } else if (locPerm == LocationPermission.deniedForever) {
          _locationStatus = LocationServiceStatus.permissionPermanentlyDenied;
        } else if (locPerm == LocationPermission.denied) {
          _locationStatus = LocationServiceStatus.permissionDenied;
        } else {
          _locationStatus = LocationServiceStatus.enabled;
        }
      });
    }
  }

  Future<void> _handleTakeCameraPhoto() async {
    setState(() {
      _isCapturingCamera = true;
      _statusBannerMessage = null;
    });

    final service = ref.read(evidenceServiceProvider);
    final result = await service.capturePhotoWithCamera(context);

    if (mounted) {
      setState(() {
        _isCapturingCamera = false;
        _cameraPermissionStatus = result.permissionStatus;
      });

      if (result.success && result.persistentPath != null) {
        setState(() {
          _capturedImagePath = result.persistentPath;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Fotografía capturada y guardada en el almacenamiento privado de la app.',
            ),
            backgroundColor: AppColors.colorSuccess,
          ),
        );
      } else if (result.cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Captura de fotografía cancelada.'),
          ),
        );
      } else if (result.permissionStatus.isPermanentlyDenied) {
        setState(() {
          _statusBannerMessage =
              'El permiso de Cámara está denegado permanentemente. Puede abrir Ajustes del Sistema para otorgarlo, o guardar la evidencia solo con texto.';
        });
      } else if (result.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage!),
            backgroundColor: AppColors.colorWarning,
          ),
        );
      }
    }
  }

  Future<void> _handleGetLocation() async {
    setState(() {
      _isFetchingLocation = true;
      _statusBannerMessage = null;
    });

    final service = ref.read(evidenceServiceProvider);
    final result = await service.getCurrentLocation(context);

    if (mounted) {
      setState(() {
        _isFetchingLocation = false;
        _locationStatus = result.status;
      });

      if (result.status == LocationServiceStatus.enabled &&
          result.position != null) {
        setState(() {
          _capturedPosition = result.position;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Coordenadas obtenidas: Lat ${result.position!.latitude.toStringAsFixed(5)}, Long ${result.position!.longitude.toStringAsFixed(5)}',
            ),
            backgroundColor: AppColors.colorSuccess,
          ),
        );
      } else if (result.status == LocationServiceStatus.disabled) {
        setState(() {
          _statusBannerMessage =
              'El servicio de ubicación (GPS) está desactivado. Actívelo en los ajustes rápidos del teléfono o guarde solo con texto.';
        });
      } else if (result.status ==
          LocationServiceStatus.permissionPermanentlyDenied) {
        setState(() {
          _statusBannerMessage =
              'El permiso de Ubicación está denegado permanentemente en el sistema. Puede abrir Ajustes para otorgarlo.';
        });
      } else if (result.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage!),
            backgroundColor: AppColors.colorWarning,
          ),
        );
      }
    }
  }

  Future<void> _handleSaveEvidence() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    final service = ref.read(evidenceServiceProvider);

    try {
      final evidence = await service.createLocalEvidence(
        description: _descriptionController.text.trim(),
        imagePath: _capturedImagePath,
        latitude: _capturedPosition?.latitude,
        longitude: _capturedPosition?.longitude,
      );

      if (mounted) {
        setState(() {
          _isSaving = false;
          _descriptionController.clear();
          _capturedImagePath = null;
          _capturedPosition = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Evidencia #${evidence.id} guardada en SQLite local (PENDING). Encolada para sincronización.',
            ),
            backgroundColor: AppColors.colorSuccess,
          ),
        );
      }

      // Sincronizar automáticamente si hay red disponible
      _triggerSync();
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar evidencia local: $e'),
            backgroundColor: AppColors.colorError,
          ),
        );
      }
    }
  }

  Future<void> _triggerSync() async {
    setState(() => _isSyncing = true);
    final syncService = ref.read(syncServiceProvider);
    final syncedCount = await syncService.processPendingQueue();

    if (mounted) {
      setState(() => _isSyncing = false);
      if (syncedCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sincronización exitosa: $syncedCount evidencia(s) enviada(s) al backend.',
            ),
            backgroundColor: AppColors.colorSuccess,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final evidencesAsync = ref.watch(evidencesStreamProvider);
    final service = ref.watch(evidenceServiceProvider);

    return AppScaffold(
      title: 'SafeAccess 90 — Evidencia de Seguridad',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacingPage),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Regresar a capacitación
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.go('/'),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Volver a Capacitación',
                      style: AppTypography.title.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Formulario para nueva evidencia
                SafeAccessSectionCard(
                  title: 'Registrar Observación de Seguridad',
                  leadingIcon: Icons.camera_alt_outlined,
                  subtitle:
                      'La fotografía y la ubicación son opcionales. En caso de denegación de permisos, puede guardar la descripción y continuar.',
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Campo de texto de observación (Obligatorio)
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Descripción de la observación *',
                            hintText:
                                'Ej. Extintor con inspección al día y área despejada en pasillo 2.',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.notes),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor ingrese una descripción de la observación.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Sección de Fotografía (Opcional)
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.colorBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.colorBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.camera_alt,
                                      color: AppColors.colorPrimary),
                                  const SizedBox(width: AppSpacing.xs),
                                  const Text(
                                    'Fotografía (Opcional)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  _buildPermissionBadge(
                                    _cameraPermissionStatus.isGranted
                                        ? 'Concedido'
                                        : _cameraPermissionStatus
                                                .isPermanentlyDenied
                                            ? 'Denegado Perm.'
                                            : 'No Concedido',
                                    _cameraPermissionStatus.isGranted
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),

                              if (_capturedImagePath != null) ...[
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_capturedImagePath!),
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black54,
                                        child: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.white),
                                          onPressed: () {
                                            setState(() {
                                              _capturedImagePath = null;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                              ],

                              SafeAccessButton(
                                label: _capturedImagePath == null
                                    ? 'Tomar Fotografía con Cámara'
                                    : 'Volver a Tomar Fotografía',
                                icon: Icons.photo_camera,
                                isLoading: _isCapturingCamera,
                                onPressed: _handleTakeCameraPhoto,
                                variant: SafeAccessButtonVariant.outline,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Sección de Ubicación GPS (Opcional)
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.colorBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.colorBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.my_location,
                                      color: AppColors.colorPrimary),
                                  const SizedBox(width: AppSpacing.xs),
                                  const Text(
                                    'Ubicación GPS (Opcional)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  _buildPermissionBadge(
                                    _locationStatus ==
                                            LocationServiceStatus.enabled
                                        ? 'GPS Activo'
                                        : _locationStatus ==
                                                LocationServiceStatus.disabled
                                            ? 'GPS Apagado'
                                            : 'Denegado',
                                    _locationStatus ==
                                            LocationServiceStatus.enabled
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),

                              if (_capturedPosition != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: AppColors.colorSuccessContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: AppColors.colorSuccess,
                                          size: 18),
                                      const SizedBox(width: AppSpacing.xs),
                                      Expanded(
                                        child: Text(
                                          'Lat: ${_capturedPosition!.latitude.toStringAsFixed(6)}, Long: ${_capturedPosition!.longitude.toStringAsFixed(6)} (Precisión: ${_capturedPosition!.accuracy.toStringAsFixed(1)}m)',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close,
                                            size: 18),
                                        onPressed: () {
                                          setState(() {
                                            _capturedPosition = null;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                              ],

                              SafeAccessButton(
                                label: _capturedPosition == null
                                    ? 'Obtener Ubicación Actual'
                                    : 'Actualizar Ubicación',
                                icon: Icons.location_searching,
                                isLoading: _isFetchingLocation,
                                onPressed: _handleGetLocation,
                                variant: SafeAccessButtonVariant.outline,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Alertas de Degradación o Denegación Permanente
                        if (_statusBannerMessage != null ||
                            _cameraPermissionStatus.isPermanentlyDenied ||
                            _locationStatus ==
                                LocationServiceStatus.permissionPermanentlyDenied) ...[
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded,
                                        color: Colors.orange.shade900),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Aviso de Permisos / Degradación',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange.shade900),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _statusBannerMessage ??
                                      'Tiene permisos denegados permanentemente. Puede presionar "Abrir Ajustes" para activarlos o continuar usando la app sin ellos.',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.orange.shade900),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      service.openAppSettingsScreen(),
                                  icon: const Icon(Icons.settings, size: 18),
                                  label: const Text('Abrir Ajustes del Sistema'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade800,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],

                        // Botón de Guardar Evidencia Local
                        SafeAccessButton(
                          label: 'Guardar Observación Local y Sincronizar',
                          icon: Icons.save_outlined,
                          isLoading: _isSaving,
                          onPressed: _handleSaveEvidence,
                          variant: SafeAccessButtonVariant.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingSection),

                // Lista de Evidencias Guardadas Localmente
                SafeAccessSectionCard(
                  title: 'Evidencias Registradas en SQLite Local (Drift)',
                  leadingIcon: Icons.list_alt_outlined,
                  subtitle:
                      'Lista de observaciones almacenadas localmente en Drift con su estado de sincronización real.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Historial de Evidencias:',
                              style: AppTypography.title),
                          SafeAccessButton(
                            label: 'Sincronizar Cola',
                            icon: Icons.sync,
                            isLoading: _isSyncing,
                            onPressed: _triggerSync,
                            variant: SafeAccessButtonVariant.outline,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      evidencesAsync.when(
                        data: (evidences) {
                          if (evidences.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppSpacing.md),
                              child: Text(
                                'No se han registrado observaciones de seguridad en este dispositivo.',
                                style: TextStyle(
                                    color: AppColors.colorTextSecondary),
                              ),
                            );
                          }

                          return Column(
                            children: evidences.map((ev) {
                              final isSynced = ev.syncStatus == 'SYNCED';
                              final hasImage =
                                  ev.imagePath != null && ev.imagePath!.isNotEmpty;
                              final hasCoords = ev.latitude != null;

                              return Card(
                                margin:
                                    const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Miniatura de imagen si existe localmente
                                      if (hasImage &&
                                          File(ev.imagePath!).existsSync())
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.file(
                                            File(ev.imagePath!),
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      else
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: AppColors.colorBackground,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: AppColors.colorBorder),
                                          ),
                                          child: const Icon(
                                            Icons.description_outlined,
                                            color: AppColors.colorTextSecondary,
                                          ),
                                        ),
                                      const SizedBox(width: AppSpacing.md),

                                      // Contenido de la evidencia
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ev.description,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            if (hasCoords)
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons.location_on_outlined,
                                                      size: 14,
                                                      color: Colors.blue),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    'GPS: ${ev.latitude!.toStringAsFixed(4)}, ${ev.longitude!.toStringAsFixed(4)}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.blue),
                                                  ),
                                                ],
                                              ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'clientId: ${ev.clientId.substring(0, 8)}...',
                                              style: AppTypography.caption
                                                  .copyWith(
                                                      color: AppColors
                                                          .colorTextSecondary),
                                            ),
                                            if (ev.serverId != null)
                                              Text(
                                                'serverId Backend: ${ev.serverId}',
                                                style: AppTypography.caption
                                                    .copyWith(
                                                        color: AppColors
                                                            .colorSuccess),
                                              ),
                                          ],
                                        ),
                                      ),

                                      // Badge de Sync Status
                                      _buildPermissionBadge(
                                        ev.syncStatus,
                                        isSynced ? Colors.green : Colors.orange,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (err, _) => Text(
                          'Error al cargar evidencias: $err',
                          style: const TextStyle(color: AppColors.colorError),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
