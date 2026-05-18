int tripClipTripCountFromBody(String body) {
  final m = RegExp(r'(\d+)').firstMatch(body);
  if (m == null) return 0;
  return int.tryParse(m.group(1)!) ?? 0;
}

bool tripClipTripSearchMatches(
  String query,
  String heading,
  String body,
) {
  final raw = query.trim();
  if (raw.isEmpty) return true;

  final q = raw.toLowerCase();
  final h = heading.toLowerCase();
  final b = body.toLowerCase();

  if (RegExp(r'^\d+$').hasMatch(raw)) {
    final want = int.tryParse(raw);
    if (want == null) return false;
    final m = RegExp(r'^(\d+)').firstMatch(body.trim());
    if (m == null) return false;
    final n = int.tryParse(m.group(1)!);
    return n == want;
  }

  return h.contains(q) || b.contains(q);
}
