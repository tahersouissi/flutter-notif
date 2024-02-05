import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final String? hintText;
  final String? initialValue;
  final String? label;
  final TextAlign? textAlign;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool? obsecureText;
  final String? validatorMessage;
  final bool? mismatchPassword;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Color? labelColor;

  const EntryField({
    Key? key,
    this.hintText,
    this.initialValue,
    this.label,
    this.textAlign,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.obsecureText,
    this.validatorMessage,
    this.mismatchPassword,
    this.onChanged,
    this.onTap,
    this.labelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label ?? '',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                // .copyWith(fontSize: 12, color: Theme.of(context).cardColor),
                .copyWith(fontSize: 12, color: labelColor ?? Colors.white),
          ),
        if (label != null) const SizedBox(height: 16),
        TextFormField(
          textAlign: textAlign ?? TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                // color: Theme.of(context).cardColor,
                color: Colors.black,
                fontSize: 12,
              ),
          initialValue: initialValue,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: hintText ?? '',
            hintStyle: Theme.of(context).textTheme.caption,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 20,
            ),
          ),
          keyboardType: keyboardType,
          controller: controller,
          obscureText: obsecureText ?? false,
          validator: (String? value) {
            if (value!.isEmpty || mismatchPassword == true) {
              return validatorMessage;
            } else if (mismatchPassword == false &&
                !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                    .hasMatch(value)) {
              return 'At least 8 characters with (abc ABC 012 @\$!%*#?&)';
            } else if (keyboardType == TextInputType.emailAddress &&
                !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                    .hasMatch(value)) {
              return 'Please enter a valid email address.';
            } else if(value.length < 3 && keyboardType == TextInputType.text) {
              return "Field must be at least 3 characters";
            } else {
              return null;
            }
          },
          onChanged: onChanged,
          cursorColor: const Color(0xFF6948CE),
          onTap: onTap,
          textInputAction: textInputAction,
        ),
      ],
    );
  }
}
