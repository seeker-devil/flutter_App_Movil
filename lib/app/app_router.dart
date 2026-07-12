import 'package:go_router/go_router.dart';
import '../features/training/training_page.dart';
import '../features/quiz/quiz_page.dart';
import '../features/certificate/certificate_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
  ],
);
