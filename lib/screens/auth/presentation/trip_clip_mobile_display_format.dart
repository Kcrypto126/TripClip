String tripClipFormatMobileDisplay(String raw) {
  var digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('61') && digits.length >= 11) {
    digits = '0${digits.substring(2)}';
  }
  if (digits.isEmpty) return raw.trim();

  if (digits.length >= 10) {
    final core = digits.substring(0, 10);
    final formatted =
        '${core.substring(0, 4)} ${core.substring(4, 7)} ${core.substring(7)}';
    if (digits.length == 10) return formatted;
    return '$formatted ${digits.substring(10)}';
  }

  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && i % 3 == 0) buf.write(' ');
    buf.write(digits[i]);
  }
  return buf.toString();
}
