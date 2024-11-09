import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:nushhack/models/indicator.dart';

class IndicatorPage extends StatelessWidget {
  final Indicator indicator;

  const IndicatorPage({Key? key, required this.indicator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(indicator.name),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${indicator.name} over Time',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Graph Section
            Expanded(
              flex: 2,
              child: _buildGraph(),
            ),
            const SizedBox(height: 16),
            // List Section
            Text(
              'All Entries',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 3,
              child: _buildEntriesList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the graph using fl_chart
  Widget _buildGraph() {
    if (indicator.values.isEmpty) {
      return const Center(child: Text('No data available'));
    }

  // Create the data points for the chart
  List<FlSpot> spots = indicator.values
      .asMap()
      .entries
      .map((entry) => FlSpot(
            entry.key.toDouble(),
            entry.value.value,
          ))
      .toList();

  double minY = indicator.values.map((e) => e.value).reduce((a, b) => a < b ? a : b);
  double maxY = indicator.values.map((e) => e.value).reduce((a, b) => a > b ? a : b);

  return LineChart(
    LineChartData(
      minX: 0,
      maxX: (indicator.values.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (maxY - minY) / 5, // Adjust the interval based on data
            reservedSize: 40,
            getTitlesWidget: (value, _) => Text(
              value.toStringAsFixed(1),
              style: const TextStyle(fontSize: 12),
            ),
            minIncluded: false,
            maxIncluded: false
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 3, // Show labels for each data point
            getTitlesWidget: (value, _) {
              if (value.toInt() >= 0 && value.toInt() < indicator.values.length) {
                DateTime date = indicator.values[value.toInt()].dateTime;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('MMM yy').format(date), // Show month and day
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }
              return const Text('');
            },
            minIncluded: false,
            maxIncluded: false
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false
          )
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false
          )
        )
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        horizontalInterval: (maxY - minY) / 5,
        verticalInterval: 1,
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: Colors.black),
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.blueAccent,
          barWidth: 3,
          dotData: FlDotData(show: false),
        ),
      ],
    ),
  );
}

  /// Builds the list of all entries
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Widget _buildEntriesList() {
    if (indicator.values.isEmpty) {
      return const Center(child: Text('No entries available'));
    }

    return ListView.builder(
      itemCount: indicator.values.length,
      itemBuilder: (context, index) {
        final entry = indicator.values[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(
              'Value: ${entry.value.toStringAsFixed(2)} ${indicator.units}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Date: ${formatDate(entry.dateTime)}'),
          ),
        );
      },
    );
  }
}
