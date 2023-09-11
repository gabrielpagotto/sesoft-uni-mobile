import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sesoft_uni_mobile/src/clients/sesoft_client.dart';
import 'package:sesoft_uni_mobile/src/models/post.dart';

part 'timeline_service.g.dart';

@riverpod
class TimelineService extends _$TimelineService {
  @override
  List build() => [];

  Future<List<Post>> fetch() async {
    final client = ref.read(sesoftClientProvider);
    final response = await client.get('/timeline');
    return response.data['result'].map<Post>((e) => Post.fromJson(e)).toList();
  }
}
