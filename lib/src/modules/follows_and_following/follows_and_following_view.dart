import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/constants/fake_data.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/services/user_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_user.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'follows_and_following_view.g.dart';

@riverpod
Future<User> user(UserRef ref, {required String userId}) async {
  return await ref.read(userServiceProvider.notifier).find(userId);
}

@Riverpod(keepAlive: true)
Future<List<User>> following(FollowingRef ref, {required String userId}) async {
  return await ref.read(userServiceProvider.notifier).userFollowing(userId);
}

@Riverpod(keepAlive: true)
Future<List<User>> followers(FollowersRef ref, {required String userId}) async {
  return await ref.read(userServiceProvider.notifier).userFollowers(userId);
}

enum FollowsAndFollowingViewTab { following, followers }

class FollowsAndFollowingView extends StatefulWidget {
  const FollowsAndFollowingView({super.key, required this.initialTab, required this.userId});

  final FollowsAndFollowingViewTab initialTab;
  final String userId;

  // ignore: constant_identifier_names
  static const ROUTE = '/follows-and-following';

  @override
  State<FollowsAndFollowingView> createState() => _FollowsAndFollowingViewState();
}

class _FollowsAndFollowingViewState extends State<FollowsAndFollowingView> with SingleTickerProviderStateMixin {
  late final tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: widget.initialTab == FollowsAndFollowingViewTab.following ? 0 : 1,
  );

  @override
  Widget build(BuildContext context) {
    return SesoftScaffold(
      titleText: "",
      appBarBottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Consumer(builder: (context, ref, _) {
          final userAsyncValue = ref.watch(userProvider(userId: widget.userId));
          return TabBar(
            controller: tabController,
            tabs: [
              Tab(child: Text('${userAsyncValue.value?.followingsCount} Seguindo')),
              Tab(child: Text('${userAsyncValue.value?.followersCount} Seguidores')),
            ],
          );
        }),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Consumer(builder: (context, ref, _) {
            final follingAsyncValue = ref.watch(followingProvider(userId: widget.userId));
            return follingAsyncValue.when(
              data: (data) {
                return ListView(
                  children: data.map((e) => SesoftUser(user: e)).toList(),
                );
              },
              error: (_, __) => Container(),
              loading: () => Skeletonizer(child: ListView(children: fakeUsersList.map((e) => SesoftUser(user: e)).toList())),
            );
          }),
          Consumer(builder: (context, ref, _) {
            final followersAsyncValue = ref.watch(followersProvider(userId: widget.userId));
            return followersAsyncValue.when(
              data: (data) {
                return ListView(
                  children: data.map((e) => SesoftUser(user: e)).toList(),
                );
              },
              error: (_, __) => Container(),
              loading: () => Skeletonizer(child: ListView(children: fakeUsersList.map((e) => SesoftUser(user: e)).toList())),
            );
          }),
        ],
      ),
    );
  }
}
