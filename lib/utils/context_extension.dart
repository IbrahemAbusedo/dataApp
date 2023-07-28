import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtension on BuildContext{

  void showSnackBar({
    required String message,
    bool erorr: false,
  })
  {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: erorr ? Colors.red.shade800 : Colors.blue.shade500,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  AppLocalizations get localizations => AppLocalizations.of(this)!;
}