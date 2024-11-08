import 'package:nushhack/models/value_entry.dart';

class Indicator {
  final double mean;
  final double stdDev;
  final String name;
  final String units;
  final List<ValueEntry> values;

  Indicator({
    required this.mean,
    required this.stdDev,
    required this.name,
    required this.units,
    required List<ValueEntry> values,
  }) : values = values..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  double get latestValue {
    if (values.isEmpty) return 0.0;
    return values.last.value;
  }

  double get averageValue {
    if (values.isEmpty) return 0.0;
    final total = values.fold(0.0, (sum, entry) => sum + entry.value);
    return total / values.length;
  }

  double get latestZScore => ZScore(latestValue);

  double get averageZScore => ZScore(averageValue);

  double ZScore(double value) {
    if (stdDev == 0) return 0.0;
    return (value - mean) / stdDev;
  }

  /// Converts the `Indicator` to a Firestore map.
  Map<String, dynamic> toFirestore() {
    return {
      'mean': mean,
      'stdDev': stdDev,
      'name': name,
      'units': units,
      'values': values.map((v) => v.toFirestore()).toList(),
    };
  }

  /// Creates an `Indicator` from a Firestore map.
  factory Indicator.fromFirestore(Map<String, dynamic> data) {
    return Indicator(
      mean: (data['mean'] as num).toDouble(),
      stdDev: (data['stdDev'] as num).toDouble(),
      name: data['name'] as String,
      units: data['units'] as String,
      values: (data['values'] as List<dynamic>)
          .map((v) => ValueEntry.fromFirestore(v as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts the `Indicator` to a JSON map.
  Map<String, dynamic> toJSON() {
    return {
      'mean': mean,
      'stdDev': stdDev,
      'name': name,
      'units': units,
      'values': values.map((v) => v.toJSON()).toList(),
    };
  }

  /// Creates an `Indicator` from a JSON map.
  factory Indicator.fromJSON(Map<String, dynamic> data) {
    return Indicator(
      mean: (data['mean'] as num).toDouble(),
      stdDev: (data['stdDev'] as num).toDouble(),
      name: data['name'] as String,
      units: data['units'] as String,
      values: (data['values'] as List<dynamic>)
          .map((v) => ValueEntry.fromJSON(v as Map<String, dynamic>))
          .toList(),
    );
  }
}
