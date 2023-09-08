import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sesoft_text_form_field.g.dart';

@riverpod
class _ObscureText extends _$ObscureText {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

class SesoftTextFormField extends ConsumerWidget {
  final String labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChange;

  const SesoftTextFormField({
    super.key,
    required this.labelText,
    required this.keyboardType,
    required this.textInputAction,
    this.controller,
    this.prefixIcon,
    this.hintText,
    this.validator,
    this.onChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obscureText = ref.watch(_obscureTextProvider);
    final toggleObscureText = ref.read(_obscureTextProvider.notifier).toggle;

    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            obscureText: obscureText,
            validator: validator,
            onChanged: onChange,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hintText,
              alignLabelWithHint: false,
              labelText: labelText,
              suffixIcon: keyboardType == TextInputType.visiblePassword
                  ? IconButton(
                      onPressed: toggleObscureText,
                      icon: obscureText ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
