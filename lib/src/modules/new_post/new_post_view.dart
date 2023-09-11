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
          Consumer(
            child: const Text('Publicar'),
            builder: (context, ref, child) {
              return SesoftElevatedButton(
                onPressed:
                    ref.watch(newPostControllerProvider.select((value) => value.canSubmit && !value.isSubmiting)) ? ref.read(newPostControllerProvider.notifier).submit : null,
                child: child!,
              );
            },
          )
        ],
      ),
      body: Consumer(builder: (context, ref, _) {
        return TextFormField(
          controller: ref.watch(newPostControllerProvider.select((value) => value.contentController)),
          keyboardType: TextInputType.multiline,
          focusNode: _inputFocusNode,
          style: context.textTheme.titleLarge,
          maxLines: 100,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Conte o que está acontecendo?',
            hintStyle: context.textTheme.titleLarge?.copyWith(
              color: context.theme.colorScheme.outline,
            ),
          ),
        );
      }),
    );
  }
}
