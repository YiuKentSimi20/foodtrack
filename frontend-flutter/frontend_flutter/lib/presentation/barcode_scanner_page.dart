import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;
  bool _torchOn = false;

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final b = capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
    if (b != null && b.isNotEmpty) {
      _scanned = true; // previne multiple detecții
      // mic delay ca userul să vadă UI
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) Navigator.of(context).pop(b);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTopBar() {
    return Positioned(
      bottom: 200,
      left: 50,
      right: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
                onPressed: () async {
                  await _controller.toggleTorch();
                  final val = await _controller.torchEnabled;
                  setState(() {
                    // lamp state can be TorchState.enabled/disabled depending on package
                    _torchOn = val == TorchState.on;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // overlay: ghid vizual
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: 260,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          _buildTopBar(),
          // hint text bottom
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Text('Aliniază codul de bare în interiorul dreptunghiului', style: TextStyle(color: Colors.white)),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}