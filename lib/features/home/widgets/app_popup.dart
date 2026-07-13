import 'package:flutter/material.dart';
import 'package:stock_app/core/theme/app_colors.dart';

class AppPopup extends StatelessWidget {
  const AppPopup({
    super.key,
    required this.title,
    required this.content,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftPressed,
    required this.onRightPressed,
    this.showCloseButton = false,
  });

  final String title;
  final String content;

  final String leftButtonText;
  final String rightButtonText;

  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;

  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (showCloseButton)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: PopupButton(
                    text: leftButtonText,
                    onPressed: onLeftPressed,
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    borderColor: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PopupButton(
                    text: rightButtonText,
                    onPressed: onRightPressed,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PopupButton extends StatelessWidget {
  const PopupButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.height = 48,
    this.borderRadius = 8,
  });

  final String text;
  final VoidCallback onPressed;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
