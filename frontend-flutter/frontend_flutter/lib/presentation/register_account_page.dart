import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/enums/nivel_activitate.dart';
import 'package:frontend_flutter/presentation/register_measurements_page.dart';
import 'package:frontend_flutter/presentation/widgets/app_date_picker_field.dart';
import '../core/api_client.dart';
import '../core/token_storage.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/models/register_request.dart';

class RegisterAccountPage extends StatefulWidget {
  const RegisterAccountPage({super.key});

  @override
  State<RegisterAccountPage> createState() => _RegisterAccountPageState();
}

class _RegisterAccountPageState extends State<RegisterAccountPage> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  late DateTime _birthDateValue = DateTime.now().subtract(Duration(days: 1));
  String _gen = 'M';
  NivelActivitate _nivel = NivelActivitate.SEDENTAR;

  final Map<String, String> _genderLabels = {
    'M': 'Masculin',
    'F': 'Feminin',
    'ALTUL': 'Altul',
  };

  

  final _formKey = GlobalKey<FormState>();

  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _birthDateError;
  String? _genError;
  String? _nivelError;

  bool _loading = false;
  String? _error;

  late final AuthRepository _repo;

  @override
  void initState() {
    super.initState();
    final tokenStorage = TokenStorage();
    _repo = AuthRepository(
      apiClient: ApiClient(tokenStorage),
      tokenStorage: tokenStorage,
    );
  }

  String? _validateUsername(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Username-ul este obligatoriu';
    if (v.length < 3 || v.length > 20) return 'Username-ul trebuie să aibă 3-20 caractere';
    return null;
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email-ul este obligatoriu';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(v)) return 'Email invalid';
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Parola este obligatorie';
    if (v.length < 8 || v.length > 64) return 'Parola trebuie să aibă 8-64 caractere';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Parola trebuie să conțină o literă mică';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Parola trebuie să conțină o literă mare';
    if (!RegExp(r'\d').hasMatch(v)) return 'Parola trebuie să conțină o cifră';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\[\]\\\/]').hasMatch(v)) {
      return 'Parola trebuie să conțină un caracter special';
    }
    return null;
  }

  void _clearFieldErrors() {
    setState(() {
      _usernameError = null;
      _emailError = null;
      _passwordError = null;
      _birthDateError = null;
      _genError = null;
      _nivelError = null;
    });
  }

  Future<void> _continue() async {
    _clearFieldErrors();

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final req = RegisterRequest(
        username: _username.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        dataNasterii: _birthDateValue.toString().split(" ").first,
        gen: _gen,
        nivelActivitate: _nivel.code,
      );

      await _repo.register(req);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => RegisterMeasurementsPage(),
        ),
      );
    } on DioException catch (e) {
      // aici tratezi 400 și fieldErrors
      final data = e.response?.data;

      if (e.response?.statusCode == 400 || e.response?.statusCode == 409 && data is Map<String, dynamic>) {
        final fieldErrors = data['fieldErrors'];

        if (fieldErrors is List) {
          for (final err in fieldErrors) {
            if (err is Map<String, dynamic>) {
              final field = err['field']?.toString();
              final message = err['message']?.toString();

              if (field != null && message != null) {
                setState(() {
                  switch (field) {
                    case 'username':
                      _usernameError = message;
                      break;
                    case 'email':
                      _emailError = message;
                      break;
                    case 'password':
                      _passwordError = message;
                      break;
                    case 'data_nasterii':
                      _birthDateError = message;
                      break;
                    case 'gen':
                      _genError = message;
                      break;
                    case 'nivel_activitate':
                      _nivelError = message;
                      break;
                    default:
                      _error = message;
                  }
                });
              }
            }
          }
          return;
        }

        final backendMessage = data['message']?.toString();
        if (backendMessage != null && backendMessage.isNotEmpty) {
          setState(() => _error = backendMessage);
          return;
        }
      }

      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creeare cont')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _username,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              validator: _validateUsername,
            ),
            if (_usernameError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  _usernameError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: _validateEmail,
            ),
            if (_emailError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  _emailError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Parolă',
              ),
              validator: _validatePassword,
            ),
            if (_passwordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  _passwordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            SizedBox(height: 12),
            TextFormField(
              controller: _confirmPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmă parola',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirmă parola';
                }
                if (value != _password.text) {
                  return 'Parolele nu coincid';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Text('Data Nașterii'),
            AppDatePickerField(
              label: 'Data nașterii',
              value: _birthDateValue,
              firstDate: DateTime(1900, 1, 1),
              lastDate: DateTime.now().subtract(const Duration(days: 1)),
              onChanged: (date) {
                setState(() {
                  _birthDateValue = date;
                  _birthDateError = null;
                });
              },
            ),
            if (_birthDateError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  _birthDateError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            DropdownButtonFormField<String>(
              initialValue: _gen,
              decoration: InputDecoration(
                labelText: 'Gen',
                helperText: null,
                errorText: _genError,
              ),
              items: _genderLabels.entries
                  .map((e) => DropdownMenuItem<String>(
                value: e.key,
                child: Text(e.value),
              ))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _gen = v;
                });
              },
              validator: (v) {
                if (v == null || v.isEmpty) return 'Te rog selectează genul';
                return null;
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _nivel.displayName,
              decoration: InputDecoration(
                labelText: 'Nivel activitate fizică',
                helperText: 'Alege cât de activ ești în mod obișnuit',
                errorText: _nivelError,
              ),
              items: NivelActivitate.values
                  .map((e) => DropdownMenuItem<String>(
                value: e.displayName,
                child: Text(e.description),
              ))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _nivel = NivelActivitate.fromCode(v);
                });
              },
              validator: (v) {
                if (v == null || v.isEmpty) return 'Te rog selectează nivelul de activitate';
                return null;
              },
            ),
            const SizedBox(height: 16),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loading ? null : _continue,
              child: _loading ? const CircularProgressIndicator() : const Text('Continuă'),
            ),
          ],
        ),
      )

    );
  }
}