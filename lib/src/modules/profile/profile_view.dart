import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/constants/fake_data.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/helpers/providers/current_user.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/modules/edit_user/edit_profile_view.dart';
import 'package:sesoft_uni_mobile/src/modules/follows_and_following/follows_and_following_view.dart';
import 'package:sesoft_uni_mobile/src/modules/profile/profile_controller.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';
import 'package:sesoft_uni_mobile/src/services/user_service.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_post.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'profile_view.g.dart';

@riverpod
Future<User> getUserProfileView(GetUserProfileViewRef ref, String? userId) async {
  if (userId == null) {
    return ref.read(currentUserProvider.future);
  } else {
    return ref.read(userServiceProvider.notifier).find(userId);
  }
}

@riverpod
Future<List<Post>> getPostsProfileView(GetPostsProfileViewRef ref, String userId) async {
  final userService = ref.read(userServiceProvider.notifier);
  return userService.userPosts(userId);
}

@riverpod
Future<List<Post>> getLikedPostsProfileView(GetLikedPostsProfileViewRef ref, String userId) async {
  final userService = ref.read(userServiceProvider.notifier);
  return userService.userPostsLiked(userId);
}

class ProfileView extends ConsumerWidget {
  final String? userId;

  const ProfileView({super.key, required this.userId});

  // ignore: constant_identifier_names
  static const ROUTE = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(getUserProfileViewProvider(userId));

    final String? userProfileId = userAsyncValue.when(
      data: (data) => data.id,
      error: (error, stack) {
        return null;
      },
      loading: () {
        return null;
      },
    );

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButton: ref.watch(authServiceProvider.select((value) => value.currentUser))?.id == userId || userId == null
            ? FloatingActionButton(
                onPressed: () => context.push(EditProfileView.ROUTE),
                child: const Icon(Icons.edit),
              )
            : null,
        body: Consumer(builder: (context, ref, child) {
          return CustomScrollView(
            controller: ref.watch(profileControllerProvider.select((value) => value.scrollController)),
            slivers: [
              SliverAppBar(
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(tabs: [
                        Tab(text: 'Postagens'),
                        Tab(text: 'Curtidas'),
                      ]),
                      Divider(height: 0),
                    ],
                  ),
                ),
                forceElevated: true,
                expandedHeight: 325,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.fadeTitle],
                  centerTitle: false,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: userAsyncValue.when(
                      data: (user) => _ProfileHeaderInfos(user),
                      error: (err, stack) => const Text("Ocorreu um erro ao buscar"),
                      loading: () => const Skeletonizer(child: _ProfileHeaderInfos(null)),
                    ),
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    Consumer(builder: (context, ref, child) {
                      final postsAsyncValue = ref.watch(getPostsProfileViewProvider(userProfileId ?? ''));

                      return postsAsyncValue.when(
                        data: (posts) {
                          return UserPostsList(posts: posts);
                        },
                        loading: () => Skeletonizer(
                          child: ListView.separated(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return const SesoftPost(post: fakePostForOnePostView);
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(height: 0);
                            },
                          ),
                        ),
                        error: (err, stack) => const Text("Ocorreu um erro ao buscar"),
                      );
                    }),
                    Consumer(builder: (context, ref, child) {
                      final likedPostsAsyncValue = ref.watch(getLikedPostsProfileViewProvider(userProfileId ?? ''));

                      return likedPostsAsyncValue.when(
                        data: (likedPosts) {
                          return UserPostsList(posts: likedPosts);
                        },
                        loading: () => Skeletonizer(
                          child: ListView.separated(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return const SesoftPost(post: fakePostForOnePostView);
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(height: 0);
                            },
                          ),
                        ),
                        error: (err, stack) => const Text("Ocorreu um erro ao buscar"),
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class UserPostsList extends ConsumerWidget {
  final List<Post> posts;

  const UserPostsList({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final post = posts[index];
              return SesoftPost(post: post);
            },
            childCount: posts.length,
          ),
        ),
      ],
    );
  }
}

class _ProfileHeaderInfos extends StatelessWidget {
  const _ProfileHeaderInfos(this.user);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.profile?.displayName ?? 'unknown display',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    user?.username == null ? 'unknown username' : '@${user!.username}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SesoftProfileIcon(
                user: user ?? const User(id: "", username: "", email: ""),
                callProfileOnClick: false,
                size: 25,
              ),
            ),
          ],
        ),
        Consumer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  user?.profile?.bio ?? 'Nada a informar na bio',
                  maxLines: 3,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.outline,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => context.push(FollowsAndFollowingView.ROUTE, extra: (FollowsAndFollowingViewTab.following, user!.id)),
                      child: _ProfileHeaderInfoFollow(count: user?.followingsCount ?? 0, label: 'Seguindo'),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => context.push(FollowsAndFollowingView.ROUTE, extra: (FollowsAndFollowingViewTab.followers, user!.id)),
                      child: _ProfileHeaderInfoFollow(count: user?.followersCount ?? 0, label: 'Seguidores'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          builder: (context, ref, child) {
            return Container(
              padding: const EdgeInsets.only(top: 10),
              height: ref.watch(profileControllerProvider.select((value) => value.infoContainerHeight)),
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: child,
            );
          },
        )
      ],
    );
  }
}

class _ProfileHeaderInfoFollow extends StatelessWidget {
  const _ProfileHeaderInfoFollow({
    required this.count,
    required this.label,
  });

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          count.toString(),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.theme.colorScheme.outline,
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
        ),
        const SizedBox(width: 2.5),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.theme.colorScheme.outline,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
