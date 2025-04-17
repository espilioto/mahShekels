extension StringHelpers on String {
  String breakOnSpace() => replaceAll(' ', '\n');
  String truncateWithEllipsis(int maxLength) => '${substring(0, maxLength)}...';
}