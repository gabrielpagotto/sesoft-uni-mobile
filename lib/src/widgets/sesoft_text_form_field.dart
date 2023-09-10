import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/stateful_value_notifier_observer.dart';

class SesoftTextFormField extends StatefulWidget {
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
  State<SesoftTextFormField> createState() => _SesoftTextFormFieldState();
}

class _SesoftTextFormFieldState extends State<SesoftTextFormField> with StatefulValueNotifierObserver<SesoftTextFormField> {
  late final obscureText = ValueNotifier(widget.keyboardType == TextInputType.visiblePassword);

  @override
  List<ValueNotifier> get notifiers => [obscureText];

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: obscureText.value,
            validator: widget.validator,
            onChanged: widget.onChange,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              hintText: widget.hintText,
              alignLabelWithHint: false,
              labelText: widget.labelText,
              suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                  ? IconButton(
                      onPressed: toggleObscureText,
                      icon: obscureText.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
