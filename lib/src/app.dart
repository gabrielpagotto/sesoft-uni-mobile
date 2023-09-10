import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/modules/auth_check/auth_check_view.dart';
import 'package:sesoft_uni_mobile/src/modules/home/home_view.dart';
import 'package:sesoft_uni_mobile/src/modules/presentation/presentation_view.dart';
import 'package:sesoft_uni_mobile/src/modules/signin/signin_view.dart';
import 'package:sesoft_uni_mobile/src/modules/signup/signup_view.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/settings/router.dart';
import 'package:sesoft_uni_mobile/src/themes/dark.dart';
import 'package:sesoft_uni_mobile/src/themes/light.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authServiceProvider, _listenAuthenticationStatusChanges);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.dark,
    );
  }

  void _listenAuthenticationStatusChanges(AuthServiceState? previous, AuthServiceState next) {
    const authRoutes = [SigninView.ROUTE, SignupView.ROUTE, PresentationView.ROUTE];
    final currentRoutePath = router.routerDelegate.currentConfiguration.fullPath;
    final currentIsAuth = authRoutes.contains(currentRoutePath);
    final redirectToAuthenticated = ![AuthStatus.unauthenticated, AuthStatus.unknown].contains(next.authStatus);
    final redirectToUnauthenticated = ![AuthStatus.authenticated, AuthStatus.unknown].contains(next.authStatus);
    if ((currentIsAuth || currentRoutePath == AuthCheckView.ROUTE) && redirectToAuthenticated) {
      router.go(HomeView.ROUTE);
    } else if ((!currentIsAuth || currentRoutePath == AuthCheckView.ROUTE) && redirectToUnauthenticated) {
      router.go(SigninView.ROUTE);
    }
  }
}
