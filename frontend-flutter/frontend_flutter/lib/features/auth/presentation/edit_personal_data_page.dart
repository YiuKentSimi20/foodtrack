import 'package:flutter/material.dart';
import '../../../core/api_client.dart';
import '../../../core/token_storage.dart';
import '../../auth/data/profile_repository.dart';
import '../presentation/widgets/app_date_picker_field.dart';

class EditPersonalDataPage extends StatefulWidget {
  final DateTime? initialBirthDate;
  final String? initialGender;
  final String? initialActivityLevel;

  const EditPersonalDataPage({
    super.key,
    this.initialBirthDate,
    this.initialGender,
    this.initialActivityLevel,
  });

  @override
  State<EditPersonalDataPage> createState() => _EditPersonalDataPageState();
}

class _EditPersonalDataPageState extends State<EditPersonalDataPage> {
  final _formKey = GlobalKey<FormState>();

  late DateTime? _birthDate;
  String? _gender;
  String? _activityLevel;

  bool _loading = false;
  String? _error;
  late final ProfileRepository _repo;

  final Map<String, String> _genderLabels = const {
    'M': 'Masculin',
    'F': 'Feminin',
    'ALTUL': 'Altul',
  };

  final Map<String, String> _activityLabels = const {
    'SEDENTAR': 'Sedentar',
    'MAI_PUTIN_ACTIV': 'Mai puțin activ',
    'ACTIV': 'Activ',
    'FOARTE_ACTIV': 'Foarte activ',
  };

  @override
  void initState() {
    super.initState();
    _birthDate = widget.initialBirthDate;
    _gender = widget.initialGender;
    _activityLevel = widget.initialActivityLevel;

    final tokenStorage = TokenStorage();
    _repo = ProfileRepository(apiClient: ApiClient(tokenStorage));
  }

  Future<void> _save() async {
    setState(() {
      _error = null;
    });

    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      setState(() => _error = 'Selectează data nașterii.');
      return;
    }
    if (_gender == null || _gender!.isEmpty) {
      setState(() => _error = 'Selectează genul.');
      return;
    }
    if (_activityLevel == null || _activityLevel!.isEmpty) {
      setState(() => _error = 'Selectează nivelul de activitate.');
      return;
    }

    setState(() => _loading = true);
    try {
      await _repo.updateDatePersonale(
        dataNasterii: _birthDate!,
        gen: _gender!,
        nivelActivitate: _activityLevel!,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificare date personale'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppDatePickerField(
              label: 'Data nașterii',
              value: _birthDate,
              firstDate: DateTime(1900),
              lastDate: DateTime.now().subtract(Duration(days: 1)),
              onChanged: (date) => setState(() => _birthDate = date),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: const InputDecoration(
                labelText: 'Gen',
                border: OutlineInputBorder(),
              ),
              items: _genderLabels.entries
                  .map(
                    (e) => DropdownMenuItem<String>(
                  value: e.key,
                  child: Text(e.value),
                ),
              )
                  .toList(),
              onChanged: (v) => setState(() => _gender = v),
              validator: (v) =>
              (v == null || v.isEmpty) ? 'Selectează genul' : null,
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _activityLevel,
              decoration: const InputDecoration(
                labelText: 'Nivel activitate fizică',
                border: OutlineInputBorder(),
              ),
              items: _activityLabels.entries
                  .map(
                    (e) => DropdownMenuItem<String>(
                  value: e.key,
                  child: Text(e.value),
                ),
              )
                  .toList(),
              onChanged: (v) => setState(() => _activityLevel = v),
              validator: (v) => (v == null || v.isEmpty)
                  ? 'Selectează nivelul de activitate'
                  : null,
            ),
            const SizedBox(height: 16),

            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _loading ? null : _save,
              icon: _loading
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.save),
              label: const Text('Salvează modificările'),
            ),
          ],
        ),
      ),
    );
  }
}