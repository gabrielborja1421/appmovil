import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> messageScaffold({
  required BuildContext context,
  required String text,
}) {
  return ScaffoldMessenger.of(
    context,
  ).showSnackBar(
    SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
