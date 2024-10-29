// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ImageModal extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ImageModal({
    super.key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  void _closeAndExecute(BuildContext context, VoidCallback action) {
    Navigator.of(context).pop();
    action();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _closeAndExecute(context, onGalleryPressed),
              child: Icon(
                Icons.perm_media_outlined,
                size: 40,
              ),
            ),
            Text(
              "or",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            GestureDetector(
              onTap: () => _closeAndExecute(context, onCameraPressed),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
