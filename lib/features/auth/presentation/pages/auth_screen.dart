import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satelite_tracker/features/auth/presentation/providers/auth_providers.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Authentication Error SnackBar
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Authentication failed: ${error.toString().split('\n').first}',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          const _AuthBackground(),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _PulsingLogo(),
                    const SizedBox(height: 40),
                    const _AuthHeader(),
                    const SizedBox(height: 64),
                    const _LoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bgGradient = RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [
        Color.alphaBlend(
          colorScheme.primary.withValues(alpha: 0.12),
          colorScheme.surface,
        ),
        colorScheme.surface,
      ],
    );

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: GridPaper(
          color: colorScheme.primary.withValues(alpha: 0.04),
          divisions: 1,
          subdivisions: 1,
          interval: 40,
        ),
      ),
    );
  }
}

class _PulsingLogo extends StatefulWidget {
  const _PulsingLogo();

  @override
  State<_PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<_PulsingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 4.0, end: 16.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _pulseController,
      child: Image.asset(
        'assets/images/satellite.png',
        fit: BoxFit.contain,
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.08),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(
                    alpha: 0.2,
                  ),
                  blurRadius: _glowAnimation.value * 1.5,
                  spreadRadius: _glowAnimation.value / 4.0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        );
      },
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Typography Application Name
        Text(
          'SATELLITE TRACKER',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
            fontFamily: 'monospace',
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),

        // Application Subtitle
        Text(
          'Real-time International Space Station tracking',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1.0,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends ConsumerWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          gradient: LinearGradient(
            colors: isLoading
                ? [
                    colorScheme.primary.withValues(alpha: 0.5),
                    colorScheme.primary.withValues(alpha: 0.3),
                  ]
                : [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.85),
                  ],
          ),
          boxShadow: [
            if (!isLoading)
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () => ref.read(authControllerProvider.notifier).signInAnonymously(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27),
            ),
            padding: EdgeInsets.zero,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'ANONYMOUS LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontFamily: 'monospace',
                  ),
                ),
        ),
      ),
    );
  }
}
