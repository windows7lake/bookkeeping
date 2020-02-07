# bookkeeping

# Command

## To generate arb file
```dart
$ flutter pub run intl_translation:extract_to_arb \
      --output-dir=lib/l10n lib/l10n/intl_localizations.dart
```

## To generate dart file according to arb file
```dart
$ flutter pub run intl_translation:generate_from_arb \
      --output-dir=lib/l10n --no-use-deferred-loading \
      lib/l10n/intl_localizations.dart lib/l10n/intl_*.arb
```