import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sesoft_uni_mobile/src/modules/auth_check/auth_check_view.dart';
import 'package:sesoft_uni_mobile/src/modules/edit_user/edit_profile_view.dart';
import 'package:sesoft_uni_mobile/src/modules/follows_and_following/follows_and_following_view.dart';
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
    GoRoute(path: ProfileView.ROUTE, builder: (context, state) => ProfileView(key: ValueKey(state.extra), userId: state.extra as String?)),
    GoRoute(path: SettingsView.ROUTE, builder: (context, state) => const SettingsView()),
    GoRoute(path: PostView.ROUTE, builder: (context, state) => PostView(postId: state.extra as String)),
    GoRoute(path: EditProfileView.ROUTE, builder: (context, state) => const EditProfileView()),
    GoRoute(
        path: FollowsAndFollowingView.ROUTE,
        builder: (context, state) {
          final extra = state.extra as (FollowsAndFollowingViewTab, String userId);
          return FollowsAndFollowingView(
            initialTab: extra.$1,
            userId: extra.$2,
          );
        }),
  ],
  navigatorKey: navigatorKey,
);
