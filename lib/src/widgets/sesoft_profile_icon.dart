import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/modules/profile/profile_view.dart';

class SesoftProfileIcon extends StatefulWidget {
  const SesoftProfileIcon({
    super.key,
    required this.user,
    this.size = 35,
    this.callProfileOnClick = true,
    this.onTap,
    this.openImageOnTap = false,
  });

  final User user;
  final bool callProfileOnClick;
  final double size;
  final VoidCallback? onTap;
  final bool openImageOnTap;

  @override
  State<SesoftProfileIcon> createState() => _SesoftProfileIconState();
}

class _SesoftProfileIconState extends State<SesoftProfileIcon> {
  late var loading = widget.user.profile?.icon?.id != null;
  String? fileDir;

  @override
  void initState() {
    if (widget.user.profile?.icon?.id != null) {
      _loadData();
    }
    super.initState();
  }

  void onTap(BuildContext context) {
    if (widget.openImageOnTap) {
      _open();
    }
    widget.onTap?.call();
    if (widget.user.id.isEmpty) {
      return;
    }
    if (!widget.callProfileOnClick) {
      return;
    }
    if (Scaffold.of(context).isDrawerOpen) {
      Scaffold.of(context).closeDrawer();
    }
    context.push(ProfileView.ROUTE, extra: widget.user.id);
  }

  Future<void> _loadData() async {
    await _loadFileDir();
    await _downloadAndSaveImage();
  }

  Future<void> _loadFileDir() async {
    final documentDirectory = await getApplicationCacheDirectory();
    fileDir = '${documentDirectory.path}/${widget.user.profile!.icon!.id!}.png';
  }

  Future<void> _downloadAndSaveImage() async {
    final file = File(fileDir!);
    if (!file.existsSync()) {
      setState(() {
        loading = true;
      });
      var response = await http.get(Uri.parse(widget.user.profile!.icon!.url!));
      file.writeAsBytesSync(response.bodyBytes);
    }
    setState(() {
      loading = false;
    });
  }

  void _open() async {
    if (fileDir != null) {
      OpenFile.open(fileDir);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Material(
        shape: const CircleBorder(),
        borderOnForeground: false,
        child: GestureDetector(
          onTap: () => onTap(context),
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: widget.size * 1.2,
            height: widget.size * 1.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.theme.dividerColor),
            ),
            child: !loading && fileDir != null
                ? Image.file(
                    File(fileDir!),
                    fit: BoxFit.cover,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Icon(Icons.person, size: widget.size),
                  ),
          ),
        ),
      ),
    );
  }
}
