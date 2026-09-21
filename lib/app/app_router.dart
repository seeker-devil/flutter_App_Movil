import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/login_page.dart';
import '../features/evaluations/evaluations_page.dart';
import '../features/training/training_page.dart';
import '../features/quiz/quiz_page.dart';
import '../features/certificate/certificate_page.dart';
import '../features/evidence/evidence_page.dart';
import '../providers/app_providers.dart';
import '../services/auth_service.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<AuthUser?>>(
      authControllerProvider,
      (_, __) => notifyListeners(),
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authControllerProvider);
    final isData = authState is AsyncData;
    final user = authState.valueOrNull;

    debugPrint('[AUTH][ROUTER] location = ${state.matchedLocation}');
    debugPrint('[AUTH][ROUTER] authState = ${authState.runtimeType} (isLoading: ${authState.isLoading}, isData: $isData, user: ${user?.email})');

    // 1. Estado Loading: mientras se verifica secure storage / autenticando, NO redirigir a /login
    if (authState.isLoading) {
      debugPrint('[AUTH][ROUTER] redirect = null (loading state)');
      return null;
    }

    final isAuthenticated = user != null;
    final isLoggingIn = state.matchedLocation == '/login';

    // 2. No autenticado e intentando acceder a ruta protegida -> /login
    if (!isAuthenticated && !isLoggingIn) {
      debugPrint('[AUTH][ROUTER] redirect = /login (unauthenticated)');
      return '/login';
    }

    // 3. Autenticado y estando en /login -> / (TrainingPage)
    if (isAuthenticated && isLoggingIn) {
      debugPrint('[AUTH][ROUTER] redirect = / (authenticated on /login)');
      return '/';
    }

    debugPrint('[AUTH][ROUTER] redirect = null (no redirection needed)');
    return null;
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const TrainingPage(),
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) => const QuizPage(),
      ),
      GoRoute(
        path: '/certificate',
        builder: (context, state) => const CertificatePage(),
      ),
      GoRoute(
        path: '/evaluations',
        builder: (context, state) => const EvaluationsPage(),
      ),
      GoRoute(
        path: '/evidence',
        builder: (context, state) => const EvidencePage(),
      ),
    ],
  );
});
