import 'package:flutter/material.dart';
import 'package:stock_app/core/theme/app_colors.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    required this.label,
    this.controller,
    this.readOnly = false,
    this.keyboardType,
    this.onTap,
    this.suffixIcon,
    this.validator,
    this.hintText,
  });

  final String label;
  final TextEditingController? controller;
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      cursorColor: AppColors.textSecondary,
      decoration: InputDecoration(
        filled: false,
        alignLabelWithHint: true,
        labelText: label,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,

        contentPadding: const EdgeInsets.only(
          left: 0,
          top: 20,
          bottom: 4,
        ),

        // Icon bên phải
        suffix: suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: suffixIcon,
              ),

        floatingLabelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
    );
  }
}
