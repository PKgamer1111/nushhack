class ValueEntry {
  final DateTime dateTime;
  final double value;

  ValueEntry(this.dateTime, this.value);

  /// Converts the `ValueEntry` to a Firestore map.
  Map<String, dynamic> toFirestore() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'value': value,
    };
  }

  /// Creates a `ValueEntry` from a Firestore map.
  factory ValueEntry.fromFirestore(Map<String, dynamic> data) {
    return ValueEntry(
      DateTime.parse(data['dateTime']),
      (data['value'] as num).toDouble(),
    );
  }

  /// Converts the `ValueEntry` to a JSON map.
  Map<String, dynamic> toJSON() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'value': value,
    };
  }

  /// Creates a `ValueEntry` from a JSON map.
  factory ValueEntry.fromJSON(Map<String, dynamic> data) {
    return ValueEntry(
      DateTime.parse(data['dateTime']),
      (data['value'] as num).toDouble(),
    );
  }
}
