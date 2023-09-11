import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/clients/sesoft_client.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';

part 'timeline_service.g.dart';

@Riverpod(keepAlive: true)
class TimelineService extends _$TimelineService {
  @override
  Future<List<Post>> build() async {
    final client = ref.read(sesoftClientProvider);
    final response = await client.get('/timeline');
    return response.data['result'].map<Post>((e) => Post.fromJson(e)).toList();
  }
}
