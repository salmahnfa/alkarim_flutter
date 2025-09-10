extension StringCasingExtension on String {
  String get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : this;

  String get capitalizeWords =>
      replaceAll('_', ' ')
          .split(' ')
          .map((word) => word.capitalizeFirst)
          .join(' ');
}