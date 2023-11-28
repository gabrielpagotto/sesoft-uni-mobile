import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/constants/host.dart';
import 'package:sesoft_uni_mobile/src/helpers/providers/app_settings.dart';
import 'package:sesoft_uni_mobile/src/modules/auth_check/auth_check_view.dart';
import 'package:sesoft_uni_mobile/src/modules/home/home_view.dart';
import 'package:sesoft_uni_mobile/src/modules/presentation/presentation_view.dart';
import 'package:sesoft_uni_mobile/src/modules/profile/profile_view.dart';
import 'package:sesoft_uni_mobile/src/modules/signin/signin_view.dart';
import 'package:sesoft_uni_mobile/src/modules/signup/signup_view.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/services/timeline_service.dart';
import 'package:sesoft_uni_mobile/src/settings/router.dart';
import 'package:sesoft_uni_mobile/src/themes/dark.dart';
import 'package:sesoft_uni_mobile/src/themes/light.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late io.Socket socket = io.io(BACKEND_WS_HOST, <String, dynamic>{
    'autoConnect': false,
    'transports': ['websocket'],
  });

  @override
  void initState() {
    socket.connect();
    socket.on('new-post-created', (data) {
      ref.invalidate(timelineServiceProvider);
      ref.invalidate(getPostsProfileViewProvider);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authServiceProvider, _listenAuthenticationStatusChanges);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ref.watch(appSettingsProvider.select((value) => value.themeMode)),
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
      router.go(PresentationView.ROUTE);
    }
  }
}
