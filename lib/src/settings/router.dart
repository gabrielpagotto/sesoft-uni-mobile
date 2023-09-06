import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/modules/signin/signin_view.dart';
import 'package:sesoft_uni_mobile/src/modules/signup/signup_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: SigninView.ROUTE,
  routes: [
    GoRoute(path: SigninView.ROUTE, builder: (context, state) => const SigninView()),
    GoRoute(path: SignupView.ROUTE, builder: (context, state) => const SignupView()),
  ],
  navigatorKey: navigatorKey,
);
