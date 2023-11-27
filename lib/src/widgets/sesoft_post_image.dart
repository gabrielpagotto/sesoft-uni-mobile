import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/models/storage.dart';

class SesoftPostImage extends StatefulWidget {
  const SesoftPostImage({
    super.key,
    this.file,
    this.storage,
    this.onRemove,
  }) : assert((file != null) ^ (storage != null));

  final File? file;
  final Storage? storage;
  final VoidCallback? onRemove;

  @override
  State<SesoftPostImage> createState() => _SesoftPostImageState();
}

class _SesoftPostImageState extends State<SesoftPostImage> {
  late var loading = widget.storage != null;
  String? fileDir;

  @override
  void initState() {
    if (widget.storage != null) {
      _loadData();
    }
    super.initState();
  }

  Future<void> _loadData() async {
    await _loadFileDir();
    await _downloadAndSaveImage();
  }

  Future<void> _loadFileDir() async {
    final documentDirectory = await getApplicationCacheDirectory();
    fileDir = '${documentDirectory.path}/${widget.storage!.id!}.png';
  }

  Future<void> _downloadAndSaveImage() async {
    final file = File(fileDir!);
    if (!file.existsSync()) {
      setState(() {
        loading = true;
      });
      var response = await http.get(Uri.parse(widget.storage!.url!));
      file.writeAsBytesSync(response.bodyBytes);
    }
    setState(() {
      loading = false;
    });
  }

  void _open() async {
    if (widget.file != null) {
      OpenFile.open(widget.file!.path);
    } else if (widget.storage != null) {
      OpenFile.open(fileDir);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!loading)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.theme.dividerColor),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onTap: _open,
                child: Image.file(
                  File(widget.file != null ? widget.file!.path : fileDir!),
                  fit: BoxFit.cover,
                  width: 150,
                  height: 200,
                ),
              ),
            ),
          ),
        if (loading)
          Container(
            width: 150,
            height: 200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator.adaptive(),
          ),
        if (widget.onRemove != null)
          Positioned(
            top: 0,
            right: 10,
            child: IconButton.filled(
              onPressed: widget.onRemove,
              icon: const Icon(Icons.close),
            ),
          ),
      ],
    );
  }
}
