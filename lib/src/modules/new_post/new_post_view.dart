import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/modules/new_post/new_post_controller.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_elevated_button.dart';

class NewPostView extends StatefulWidget {
  const NewPostView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/new-post';

  @override
  State<NewPostView> createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> {
  final _inputFocusNode = FocusNode();

  @override
  void initState() {
    _inputFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Consumer(
              child: const Text('Publicar'),
              builder: (context, ref, child) {
                return SesoftElevatedButton(
                  onPressed:
                      ref.watch(newPostControllerProvider.select((value) => value.canSubmit && !value.isSubmiting)) ? ref.read(newPostControllerProvider.notifier).submit : null,
                  child: child!,
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: Consumer(builder: (context, ref, _) {
        return FloatingActionButton.small(
          onPressed: ref.read(newPostControllerProvider.notifier).selectDeviceFiles,
          child: const Icon(Icons.image),
        );
      }),
      body: Consumer(builder: (context, ref, _) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextFormField(
                    controller: ref.watch(newPostControllerProvider.select((value) => value.contentController)),
                    keyboardType: TextInputType.multiline,
                    focusNode: _inputFocusNode,
                    style: context.textTheme.titleLarge,
                    minLines: 3,
                    maxLines: 40,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Conte o que está acontecendo?',
                      hintStyle: context.textTheme.titleLarge?.copyWith(
                        color: context.theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Consumer(builder: (context, ref, _) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 70, left: 10),
                        child: Row(
                          children: ref.watch(newPostControllerProvider).files.map(
                            (file) {
                              return Stack(
                                children: [
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
                                        onTap: () => ref.read(newPostControllerProvider.notifier).showFile(file),
                                        child: Image.file(
                                          File(file.path),
                                          fit: BoxFit.cover,
                                          width: 150,
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child: IconButton.filled(
                                      onPressed: () => ref.read(newPostControllerProvider.notifier).removeFile(file),
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
