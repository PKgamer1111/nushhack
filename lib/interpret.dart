import 'package:flutter/material.dart';
import 'package:nushhack/models/indicator.dart';
import 'package:nushhack/viewmodel.dart';
import 'package:provider/provider.dart';

class InterpretPage extends StatelessWidget {
  const InterpretPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<Viewmodel>(context);
    final List<Indicator> indicators = viewModel.list;

    // Compute the absolute Z-Scores and sort in descending order
    List<Map<String, dynamic>> sortedIndicators = indicators
        .map((indicator) {
          double zScore = indicator.latestZScore;
          return {
            'indicator': indicator,
            'zScore': zScore.abs(),
          };
        })
        .toList()
      ..sort((a, b) => (b['zScore'] as double).compareTo(a['zScore'] as double));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interpret'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: sortedIndicators.length,
          itemBuilder: (context, index) {
            final item = sortedIndicators[index];
            final Indicator indicator = item['indicator'];
            final double zScore = item['zScore'];

            // Determine the color based on the severity of the Z-Score
            Color color;
            if (zScore < 1) {
              color = Colors.green;
            } else if (zScore < 2) {
              color = Colors.yellow;
            } else {
              color = Colors.red;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
                color: color.withOpacity(0.1),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    indicator.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    'Latest Value: ${indicator.values.isNotEmpty ? indicator.values.last.value.toStringAsFixed(2) : 'N/A'} ${indicator.units}\n'
                    'Z-Score: ${indicator.latestZScore.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: Icon(
                    Icons.circle,
                    color: color,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
