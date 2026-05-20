import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/token_storage.dart';
import '../../../core/api_client.dart';
import '../../aliment/data/aliment_repository.dart';
import 'aliment_details_page.dart';

class FoodRecognitionPage extends StatefulWidget {
  const FoodRecognitionPage({super.key});

  @override
  State<FoodRecognitionPage> createState() => _FoodRecognitionPageState();
}

class _FoodRecognitionPageState extends State<FoodRecognitionPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _loading = false;
  String? _error;
  File? _capturedImage;
  late final AlimentRepository _repo;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);
    _repo = AlimentRepository(apiClient: apiClient);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _controller = CameraController(_cameras![0], ResolutionPreset.high);
        await _controller!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Eroare cameră: $e');
      }
    }
  }

  Future<void> _capturePhoto() async {
    try {
      final image = await _controller!.takePicture();
      setState(() => _capturedImage = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eroare captură: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      setState(() => _capturedImage = File(image.path));
    }
  }

  Future<void> _recognizeFood() async {
    if (_capturedImage == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final aliment = await _repo.predictFoodFromImage(_capturedImage!);

      if (mounted) {
        Navigator.of(context).pop(aliment);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_capturedImage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recunoaștere Mâncare')),
        body: Column(
          children: [
            Expanded(
              child: Image.file(_capturedImage!, fit: BoxFit.cover),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _loading ? null : () => setState(() => _capturedImage = null),
                    icon: const Icon(Icons.close),
                    label: const Text('Reia'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _recognizeFood,
                    icon: _loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check),
                    label: const Text('Recunoaște'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recunoaștere Mâncare')),
        body: Center(
          child: _error != null
              ? Text(_error!, style: const TextStyle(color: Colors.red))
              : const CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Recunoaștere Mâncare')),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Aliniază mâncarea în centrul ecranului',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, color: Colors.white, size: 28),
                      onPressed: _pickFromGallery,
                      tooltip: 'Galerieie',
                    ),
                    FloatingActionButton(
                      onPressed: _capturePhoto,
                      child: const Icon(Icons.camera_alt),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Închide',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}