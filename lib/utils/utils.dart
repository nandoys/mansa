import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackbar(BuildContext context, String content) {
  final snackBar = SnackBar(content: Text(content));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<XFile?> openGallery(BuildContext context) async {
  XFile? photo;

  try {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedPhoto = await picker.pickImage(source: ImageSource.gallery);
    if (pickedPhoto != null) {
      photo = pickedPhoto;
    }
  } catch (error) {
    if (!context.mounted) return photo;
    showSnackbar(context, error.toString());
  }

  return photo;
}