import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_logo.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';

class AuthCheckView extends ConsumerStatefulWidget {
  const AuthCheckView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/auth-check';

  @override
  ConsumerState<AuthCheckView> createState() => _AuthCheckViewState();
}

class _AuthCheckViewState extends ConsumerState<AuthCheckView> {
  @override
  void initState() {
    ref.read(authServiceProvider.notifier).verifyAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SesoftScaffold(
      body: Align(child: SesoftLogo()),
    );
  }
}
