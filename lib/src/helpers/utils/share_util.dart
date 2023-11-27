import 'package:sesoft_uni_mobile/src/models/post.dart';
import 'package:share_plus/share_plus.dart';

abstract class ShareUtil {
  static Future<void> sharePost(Post post) async {
    await Share.share('https://sesoft-uni-web.vercel.app/home/post/${post.id}');
  }
}
