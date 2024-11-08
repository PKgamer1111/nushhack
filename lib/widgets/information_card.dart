import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'text_info.dart';
import 'gauge_indicator.dart';

class InformationList extends StatefulWidget {
  const InformationList({
    Key? key,
    required this.bloodPressure,
    required this.heartRate,
    required this.cholesterol,
    required this.glucoseLevel,
    required this.bmi,
    required this.condition,
    required this.oxygenSaturation,
    required this.bodyTemperature,
  }) : super(key: key);

  final String bloodPressure;
  final int heartRate;
  final int cholesterol;
  final int glucoseLevel;
  final double bmi;
  final String condition;
  final int oxygenSaturation;
  final double bodyTemperature;

  @override
  State<InformationList> createState() => _InformationListState();
}

class _InformationListState extends State<InformationList> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  late final List<Map<String, dynamic>> healthData;

  @override
  void initState() {
    super.initState();
    healthData = [
      {'type': 'text', 'label': 'Blood Pressure', 'value': widget.bloodPressure, 'color': Colors.blue},
      {'type': 'text', 'label': 'Heart Rate', 'value': '${widget.heartRate} bpm', 'color': Colors.orange},
      {'type': 'text', 'label': 'Cholesterol', 'value': '${widget.cholesterol} mg/dL', 'color': Colors.purple},
      {'type': 'text', 'label': 'Glucose Level', 'value': '${widget.glucoseLevel} mg/dL', 'color': Colors.teal},
      {'type': 'text', 'label': 'Oxygen Saturation', 'value': '${widget.oxygenSaturation}%', 'color': Colors.green},
      {'type': 'text', 'label': 'Body Temperature', 'value': '${widget.bodyTemperature} °C', 'color': Colors.red},
      {
        'type': 'gauge',
        'label': 'BMI',
        'value': widget.bmi,
        'condition': widget.condition,
        'ranges': [
          LinearGaugeRange(startValue: 10, endValue: 18.5, color: Colors.blue),
          LinearGaugeRange(startValue: 18.5, endValue: 24.9, color: Colors.green),
          LinearGaugeRange(startValue: 25, endValue: 29.9, color: Colors.yellow),
          LinearGaugeRange(startValue: 30, endValue: 40, color: Colors.red),
        ]
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = healthData
        .where((item) => item['label'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 500, // Adjust this height as needed
        maxWidth: 800,  // Adjust this width as needed
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Docked Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Scrollable List within Constrained Space
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final item = filteredData[index];
                    if (item['type'] == 'text') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextInfo(
                              label: item['label'],
                              value: item['value'],
                              color: item['color'],
                            ),
                          ),
                        ),
                      );
                    } else if (item['type'] == 'gauge') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GaugeIndicator(
                              value: item['value'],
                              min: 10,
                              max: 40,
                              ranges: item['ranges'],
                              label: item['label'],
                              condition: item['condition'],
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}