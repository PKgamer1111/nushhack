
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

  // ignore: non_constant_identifier_names
  double ZScore(double value) {
    if (stdDev == 0) return 0.0;
    return (value - mean) / stdDev;
  }
}

class ValueEntry {
  final DateTime dateTime;
  final double value;

  ValueEntry(this.dateTime, this.value);
}