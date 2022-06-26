import 'package:intl/intl.dart';

String formatPrice({devise, montant})
{
  var m = double.tryParse("$montant");
  if (m == null) {
    return '';
  }
  var k = NumberFormat.currency(name: '', locale: 'eu').format(m);
  var d = (devise ?? "").trim().toUpperCase();
  return ("$d $k").trim();
}
