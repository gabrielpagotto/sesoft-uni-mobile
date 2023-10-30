import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/clients/sesoft_client.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:sesoft_uni_mobile/src/services/auth_service.dart';

part 'timeline_service.g.dart';

@Riverpod(keepAlive: true)
class TimelineService extends _$TimelineService {
  Future<List<Post>> _getPosts() async {
    final client = ref.read(sesoftClientProvider);
    final authStatus = ref.watch(authServiceProvider.select((value) => value.authStatus));
    if (authStatus == AuthStatus.authenticated) {
      final response = await client.get('/timeline');
      return response.data['result'].map<Post>((e) => Post.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<List<Post>> build() async {
    return _getPosts();
  }

  void refresh() {
    update((p0) => _getPosts());
  }

  Future<void> setPostLiked(String id) async {
    final dataAsyncValue = state.asData;
    var posts = dataAsyncValue?.value ?? [];
    posts = posts.map((e) {
      if (e.id == id) {
        return e.copyWith(liked: true);
      }
      return e;
    }).toList();
    update((p0) => posts);
  }
}
