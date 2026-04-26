import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/providers.dart';
import '../core/constants/app_constants.dart';
import '../features/feed/feed_screen.dart';
import '../features/onboarding/welcome_screen.dart';
import 'theme/app_theme.dart';

class BolDoApp extends StatelessWidget {
  const BolDoApp({
    required this.firebaseReady,
    this.startupError,
    this.requireAuth = true,
    super.key,
  });

  final bool firebaseReady;
  final Object? startupError;
  final bool requireAuth;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: _AppRoot(
        firebaseReady: firebaseReady,
        startupError: startupError,
        requireAuth: requireAuth,
      ),
    );
  }
}

class _AppRoot extends ConsumerStatefulWidget {
  const _AppRoot({
    required this.firebaseReady,
    this.startupError,
    required this.requireAuth,
  });

  final bool firebaseReady;
  final Object? startupError;
  final bool requireAuth;

  @override
  ConsumerState<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<_AppRoot> {
  bool _showOnboarding = true;
  bool _signInStarted = false;

  Future<void> _ensureAnonymousAuth() async {
    if (_signInStarted) return;
    _signInStarted = true;
    await ref.read(authServiceProvider).signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.requireAuth) {
      return _buildAppFlow();
    }

    if (!widget.firebaseReady) {
      return _FirebaseSetupScreen(error: widget.startupError);
    }

    final authState = ref.watch(authStateChangesProvider);
    if (authState.isLoading) {
      return const _SplashScreen();
    }

    if (authState.hasError) {
      return _FirebaseSetupScreen(error: authState.error);
    }

    if (authState.value == null) {
      _ensureAnonymousAuth();
      return const _SplashScreen();
    }

    return _buildAppFlow();
  }

  Widget _buildAppFlow() {
    if (_showOnboarding) {
      return WelcomeScreen(
        onStart: () => setState(() => _showOnboarding = false),
        onSkip: () => setState(() => _showOnboarding = false),
      );
    }
    return const FeedScreen();
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _FirebaseSetupScreen extends StatelessWidget {
  const _FirebaseSetupScreen({this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 56),
              const SizedBox(height: 12),
              Text(
                'Firebase is not configured yet',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Run FlutterFire setup and enable Anonymous Auth in Firebase Console.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(
                  '$error',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
