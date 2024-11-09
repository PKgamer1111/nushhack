import 'package:flutter/material.dart';
import 'package:nushhack/models/indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeIndicator extends StatelessWidget {
  final Indicator indicator;

  const GaugeIndicator({
    Key? key,
    required this.indicator,
  }) : super(key: key);

  double get zScore => indicator.latestZScore;

  @override
  Widget build(BuildContext context) {
    // Color ranges for the gauge
    final List<LinearGaugeRange> ranges = [
      LinearGaugeRange(
        startValue: -3,
        endValue: -1,
        color: Colors.red,
      ),
      LinearGaugeRange(
        startValue: -1,
        endValue: 1,
        color: Colors.green,
      ),
      LinearGaugeRange(
        startValue: 1,
        endValue: 3,
        color: Colors.red,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SfLinearGauge(
          minimum: -3,
          maximum: 3,
          ranges: ranges,
          showLabels: false, // Hides the numerical labels
          showTicks: true, // Shows only the ticks
          majorTickStyle: const LinearTickStyle(
            length: 10,
            thickness: 2,
          ),
          minorTickStyle: const LinearTickStyle(
            length: 6,
            thickness: 1.5,
          ),
          markerPointers: [
            // Inverted triangle pointer to show the current Z-score
            LinearShapePointer(
              value: zScore,
              shapeType: LinearShapePointerType.invertedTriangle,
              color: Colors.black,
              position: LinearElementPosition.cross,
            ),
          ],
          axisTrackStyle: const LinearAxisTrackStyle(
            thickness: 16,
            edgeStyle: LinearEdgeStyle.bothCurve,
          ),
        ),
      ],
    );
  }
}
