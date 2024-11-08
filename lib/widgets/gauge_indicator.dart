import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeIndicator extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final List<LinearGaugeRange> ranges;
  final String label;

  const GaugeIndicator({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.ranges,
    required this.label,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Displaying the label and value
            Text(
              '$label: ${value.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            // Displaying the condition

          ],
        ),
        
        ),
        const SizedBox(height: 10),
        SfLinearGauge(
          minimum: min,
          maximum: max,
          ranges: ranges,
          markerPointers: [
            // Inverted triangle pointer showing the current value
            LinearShapePointer(
              value: value,
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