import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/api_client.dart';
import '../../../../core/constants/macro_colors.dart';

import '../../../../core/token_storage.dart';
import '../../../masuratori/data/masuratori_repository.dart';
import '../../../masuratori/models/obiectiv_dto.dart';
import '../../../masuratori/models/obiectiv_response.dart';
import '../today_jurnal_page.dart';
import '../widgets/objecive_card.dart';

class ManualObjectivePage extends StatefulWidget {
  final String mode;
  const ManualObjectivePage({
    required this.mode,
    super.key
  });

  @override
  State<ManualObjectivePage> createState() => _ManualObjectivePageState();
}

class _ManualObjectivePageState extends State<ManualObjectivePage> {
  late final MasuratoriRepository _masRepo;

  final _proteinCtrl = TextEditingController();
  final _carbCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();

  ObiectivResponse? _preview;
  bool _previewLoading = false;
  Timer? _debounce;

  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _masRepo = MasuratoriRepository(apiClient: ApiClient(TokenStorage()));
    _proteinCtrl.addListener(_updatePreview);
    _carbCtrl.addListener(_updatePreview);
    _fatCtrl.addListener(_updatePreview);
  }

  double? _parse(String s) {
    if (s.trim().isEmpty) return null;
    return double.tryParse(s.replaceAll(',', '.'));
  }

  double? get _proteinG => _parse(_proteinCtrl.text);
  double? get _carbG => _parse(_carbCtrl.text);
  double? get _fatG => _parse(_fatCtrl.text);

  double? get _kcal {
    final p = _proteinG;
    final c = _carbG;
    final f = _fatG;
    if (p == null || c == null || f == null) return null;
    return (p * 4) + (c * 4) + (f * 9);
  }

  bool get _isValid => _proteinG != null && _carbG != null && _fatG != null;

  void _updatePreview() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _fetchPreview();
    });
  }

  Future<void> _fetchPreview() async {
    final p = _proteinG;
    final c = _carbG;
    final f = _fatG;

    if (p == null || c == null || f == null) {
      if (mounted) {
        setState(() {
          _preview = null;
        });
      }
      return;
    }

    final kcal = (p * 4) + (c * 4) + (f * 9);

    setState(() {
      _previewLoading = true;
      _error = null;
    });

    try {
      final preview = await _masRepo.previewObiectiv(
          ObiectivDto(
            dataMasuratoare: DateTime.now(),
            obiectivCaloriiZi: kcal,
            obiectivProteineZi: p,
            obiectivCarbohidratiZi: c,
            obiectivGrasimiZi: f,
        )
      );

      if (!mounted) return;
      setState(() {
        _preview = preview;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _preview = null;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _previewLoading = false);
    }
  }

  Future<void> _save() async {
    if (!_isValid) return;

    setState(() => _error = null);
    setState(() => _saving = true);

    try {
      await _masRepo.createObiectiv(
        dataMasuratoare: DateTime.now().toIso8601String().split('T').first,
        calorii: _kcal!,
        proteine: _proteinG!,
        carbohidrati: _carbG!,
        grasimi: _fatG!,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Obiectiv salvat cu succes')),
      );
      if(widget.mode == 'register') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const TodayJournalPage()),
              (route) => false,
        );
      }
      else {
        Navigator.of(context).pop(true);
      }

    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      setState(() => _error = msg);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _proteinCtrl.dispose();
    _carbCtrl.dispose();
    _fatCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setează obiectiv manual')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 16),
          ],
          Text('Introduceți valorile zilnice', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _proteinCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Proteine (g)',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.circle, color: MacroColors.proteins, size: 12),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _carbCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Carbohidrați (g)',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.circle, color: MacroColors.carbs, size: 12),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _fatCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Grăsimi (g)',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.circle, color: MacroColors.fats, size: 12),
            ),
          ),
          if (_isValid) ...[
            const SizedBox(height: 24),
            Text('Preview obiectiv', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            if (_previewLoading)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_preview != null)
              ObjectiveCard( // dacă ai widget separat
                obiectivTitle: "Noul obiectiv",
                obiectiv: _preview!,
              )
            else
              const Text('Nu s-a putut genera preview-ul'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.check),
              label: const Text('Salvează obiectivul'),
            ),
          ],
        ],
      ),
    );
  }
}