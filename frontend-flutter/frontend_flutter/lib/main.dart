import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'core/api_client.dart';
import 'core/token_storage.dart';
import 'presentation/login_page.dart';
import 'core/theme.dart';
import 'presentation/obiective/add_obiectiv_page.dart';
import 'presentation/register_measurements_page.dart';
import 'presentation/today_jurnal_page.dart';
import 'features/masuratori/data/masuratori_repository.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final refreshTrigger = ValueNotifier<int>(0);

void main() {
  runApp(const FoodTrackApp());
}

class FoodTrackApp extends StatelessWidget {
  const FoodTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'FoodTrack',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: const StartupGate(),
    );
  }
}

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  late Future<Widget> _nextPage;

  @override
  void initState() {
    super.initState();
    _nextPage = _resolveStartupPage();
  }

  Future<Widget> _resolveStartupPage() async {
    final tokenStorage = TokenStorage();
    final token = await tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      return const LoginPage();
    }

    try {
      final client = ApiClient(tokenStorage);

      // verificăm token-ul + contul
      await client.dio.get('/foodtrack/utilizator/date-personale');

      // verificăm dacă are măsurători și obiectiv
      final masRepo = MasuratoriRepository(apiClient: client);

      final results = await Future.wait([
        masRepo.fetchGreutate(),
        masRepo.fetchObiective(),
      ]);

      final greutati = results[0] as List;
      final obiective = results[1] as List;

      if (greutati.isEmpty) {
        return const RegisterMeasurementsPage();
      }

      if (obiective.isEmpty) {
        return const NewObiectivPage(mode: 'register');
      }

      return const TodayJournalPage();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await tokenStorage.clearToken();
        return const LoginPage();
      }
      return const LoginPage();
    } catch (_) {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _nextPage,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return snapshot.data!;
      },
    );
  }
}


// class StartupGate extends StatefulWidget {
//   const StartupGate({super.key});
//
//   @override
//   State<StartupGate> createState() => _StartupGateState();
// }
//
// class _StartupGateState extends State<StartupGate> {
//   late Future<bool> _hasToken;
//
//   @override
//   void initState() {
//     super.initState();
//     _hasToken = _checkToken();
//   }
//
//   Future<bool> _checkToken() async {
//     final tokenStorage = TokenStorage();
//     final token = await tokenStorage.getToken();
//     if (token == null || token.isEmpty) return false;
//
//     try {
//       final client = ApiClient(tokenStorage);
//       await client.dio.get('/foodtrack/utilizator/date-personale');
//       return true;
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 401) {
//         await tokenStorage.clearToken();
//       }
//       return false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: _hasToken,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         if (snapshot.data == true) {
//           return const TodayJournalPage();
//         }
//
//         return const LoginPage();
//       },
//     );
//   }
// }