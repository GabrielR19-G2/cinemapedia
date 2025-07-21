import 'package:intl/intl.dart';

// Clase abierta a la extensión pero cerradas a la modificacion.
class HumanFormats {
  static String number(double number, [int decimals = 0]) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en',
    ).format(number);
    return formattedNumber;
  }
}
