class Formatters {
  Formatters._();

  /// 1499 -> ₹1,499   |   1499.5 -> ₹1,499.50
  static String price(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return parts[1] == '00' ? '₹$whole' : '₹$whole.${parts[1]}';
  }

  static String dateTime(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}, ${two(d.hour)}:${two(d.minute)}';
  }
}
