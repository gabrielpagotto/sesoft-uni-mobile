import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/modules/auth_check/auth_check_view.dart';
import 'package:sesoft_uni_mobile/src/modules/home/home_view.dart';
import 'package:sesoft_uni_mobile/src/modules/new_post/new_post_view.dart';
import 'package:sesoft_uni_mobile/src/modules/post/post_view.dart';
import 'package:sesoft_uni_mobile/src/modules/presentation/presentation_view.dart';
import 'package:sesoft_uni_mobile/src/modules/profile/profile_view.dart';
import 'package:sesoft_uni_mobile/src/modules/settings/settings_view.dart';
import 'package:sesoft_uni_mobile/src/modules/signin/signin_view.dart';
import 'package:sesoft_uni_mobile/src/modules/signup/signup_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: AuthCheckView.ROUTE,
  routes: [
    GoRoute(path: AuthCheckView.ROUTE, builder: (context, state) => const AuthCheckView()),
    GoRoute(path: PresentationView.ROUTE, builder: (context, state) => const PresentationView()),
    GoRoute(path: SigninView.ROUTE, builder: (context, state) => const SigninView()),
    GoRoute(path: SignupView.ROUTE, builder: (context, state) => const SignupView()),
    GoRoute(path: HomeView.ROUTE, builder: (context, state) => const HomeView()),
    GoRoute(path: NewPostView.ROUTE, builder: (context, state) => const NewPostView()),
    GoRoute(path: ProfileView.ROUTE, builder: (context, state) => ProfileView(userId: state.extra as String?)),
    GoRoute(path: SettingsView.ROUTE, builder: (context, state) => const SettingsView()),
    GoRoute(path: PostView.ROUTE, builder: (context, state) => PostView(postId: state.extra as String)),
  ],
  navigatorKey: navigatorKey,
);
