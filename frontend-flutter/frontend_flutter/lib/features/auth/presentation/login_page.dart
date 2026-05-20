import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/auth/presentation/register_account_page.dart';
import 'package:frontend_flutter/features/auth/presentation/today_jurnal_page.dart';
import '../../../core/api_client.dart';
import '../../../core/token_storage.dart';
import '../data/auth_repository.dart';
import '../models/authentication_request.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  late final TokenStorage _tokenStorage;
  late final AuthRepository _authRepository;

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tokenStorage = TokenStorage();
    _authRepository = AuthRepository(
      apiClient: ApiClient(_tokenStorage),
      tokenStorage: _tokenStorage,
    );
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authRepository.login(
        AuthenticationRequest(
          identifier: _identifierController.text.trim(),
          password: _passwordController.text,
        ),
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TodayJournalPage()),
      );
    } catch (e) {
      _passwordController.clear();
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
      appBar: AppBar(title: const Text('FoodTrack Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _identifierController,
              decoration: const InputDecoration(
                labelText: 'Email sau username',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Parola'),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      )
                    : const Text('Login'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loading
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RegisterAccountPage(),
                        ),
                      );
                    },
              child: const Text('Creează cont'),
            ),
          ],
        ),
      ),
    );
  }
}
