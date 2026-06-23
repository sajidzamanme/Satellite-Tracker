import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:satelite_tracker/features/auth/presentation/pages/auth_screen.dart';
import 'package:satelite_tracker/features/auth/presentation/providers/auth_providers.dart';
import 'package:satelite_tracker/features/map/presentation/pages/map_screen.dart';

part 'router.g.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(
      authStateProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }
}

@Riverpod(keepAlive: true)
RouterNotifier routerNotifier(RouterNotifierRef ref) {
  return RouterNotifier(ref);
}

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MapScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);

      if (authState.isLoading) {
        return null;
      }
      
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.uri.path == '/login';

      if (!isLoggedIn) {
        return '/login';
      }
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }
      return null;
    },
  );
}
