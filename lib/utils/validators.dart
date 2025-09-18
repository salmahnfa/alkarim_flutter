class Validators {
  static String? requiredNumber(String? value,
      {String fieldName = 'Field', int? min, int? max}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    final numValue = int.tryParse(value);
    if (numValue == null || numValue < 1) return 'Masukkan angka yang valid';
    if (min != null && numValue < min) return '$fieldName tidak boleh kurang dari $min';
    if (max != null && numValue > max) return '$fieldName tidak boleh lebih dari $max';
    return null;
  }
}
