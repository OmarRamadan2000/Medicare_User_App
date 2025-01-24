import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppLocalization {
  static AppLocalizations? _localizedStrings;

  /// Initializes the localization instance with the given context.
  static void initialize(BuildContext context) {
    // print("Localization initialized successfully");
    _localizedStrings = AppLocalizations.of(context);
  }

  /// Provides access to the localized strings, with fallback to an empty instance.
  static AppLocalizations get strings {
    if (_localizedStrings == null) {
      // You can handle this more gracefully (e.g., returning a default localization or null-safe values)
      throw Exception(
          "AppLocalization is not initialized. Call initialize() first.");
    }
    return _localizedStrings!;
  }
}
