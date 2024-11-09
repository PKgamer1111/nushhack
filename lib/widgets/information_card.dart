import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'text_info.dart';
import 'gauge_indicator.dart';

class InformationList extends StatefulWidget {
  const InformationList({
    Key? key,
    this.bloodPressure,
    this.heartRate,
    this.totalCholesterol,
    this.ldlCholesterol,
    this.hdlCholesterol,
    this.triglycerides,
    this.fastingGlucose,
    this.hba1c,
    this.bmi,
    this.oxygenSaturation,
    this.bodyTemperature,
    this.respiratoryRate,
    this.waistCircumference,
    this.hipCircumference,
    this.waistToHipRatio,
    this.bodyFatPercentage,
    this.muscleMass,
    this.boneDensity,
    this.basalMetabolicRate,
    this.vo2Max,
  }) : super(key: key);

  final String? bloodPressure; // e.g., '120/80 mmHg'
  final int? heartRate; // in bpm
  final int? totalCholesterol; // in mg/dL
  final int? ldlCholesterol; // in mg/dL
  final int? hdlCholesterol; // in mg/dL
  final int? triglycerides; // in mg/dL
  final int? fastingGlucose; // in mg/dL
  final double? hba1c; // in %
  final double? bmi; // Body Mass Index
  final int? oxygenSaturation; // in %
  final double? bodyTemperature; // in °C
  final int? respiratoryRate; // in breaths per minute
  final double? waistCircumference; // in cm
  final double? hipCircumference; // in cm
  final double? waistToHipRatio; // ratio
  final double? bodyFatPercentage; // in %
  final double? muscleMass; // in kg
  final double? boneDensity; // in g/cm²
  final int? basalMetabolicRate; // in kcal/day
  final double? vo2Max; // in mL/kg/min

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
      if (widget.bloodPressure != null)
        {
          'type': 'text',
          'label': 'Blood Pressure',
          'value': widget.bloodPressure,
          'color': Colors.blue,
        },
      if (widget.heartRate != null)
        {
          'type': 'gauge',
          'label': 'Heart Rate',
          'value': widget.heartRate!.toDouble(),
          'unit': 'bpm',
          'ranges': [
            LinearGaugeRange(startValue: 60, endValue: 100, color: Colors.green),
            LinearGaugeRange(startValue: 100, endValue: 120, color: Colors.yellow),
            LinearGaugeRange(startValue: 120, endValue: 150, color: Colors.red),
          ],
        },
      if (widget.totalCholesterol != null)
        {
          'type': 'gauge',
          'label': 'Total Cholesterol',
          'value': widget.totalCholesterol!.toDouble(),
          'unit': 'mg/dL',
          'ranges': [
            LinearGaugeRange(startValue: 0, endValue: 200, color: Colors.green),
            LinearGaugeRange(startValue: 200, endValue: 239, color: Colors.yellow),
            LinearGaugeRange(startValue: 240, endValue: 300, color: Colors.red),
          ],
        },
      if (widget.ldlCholesterol != null)
        {
          'type': 'gauge',
          'label': 'LDL Cholesterol',
          'value': widget.ldlCholesterol!.toDouble(),
          'unit': 'mg/dL',
          'ranges': [
            LinearGaugeRange(startValue: 0, endValue: 100, color: Colors.green),
            LinearGaugeRange(startValue: 100, endValue: 159, color: Colors.yellow),
            LinearGaugeRange(startValue: 160, endValue: 190, color: Colors.red),
          ],
        },
      if (widget.hdlCholesterol != null)
        {
          'type': 'gauge',
          'label': 'HDL Cholesterol',
          'value': widget.hdlCholesterol!.toDouble(),
          'unit': 'mg/dL',
          'ranges': [
            LinearGaugeRange(startValue: 0, endValue: 40, color: Colors.red),
            LinearGaugeRange(startValue: 40, endValue: 60, color: Colors.yellow),
            LinearGaugeRange(startValue: 60, endValue: 100, color: Colors.green),
          ],
        },
      if (widget.triglycerides != null)
        {
          'type': 'gauge',
          'label': 'Triglycerides',
          'value': widget.triglycerides!.toDouble(),
          'unit': 'mg/dL',
          'ranges': [
            LinearGaugeRange(startValue: 0, endValue: 150, color: Colors.green),
            LinearGaugeRange(startValue: 150, endValue: 199, color: Colors.yellow),
            LinearGaugeRange(startValue: 200, endValue: 500, color: Colors.red),
          ],
        },
      if (widget.fastingGlucose != null)
        {
          'type': 'gauge',
          'label': 'Fasting Glucose',
          'value': widget.fastingGlucose!.toDouble(),
          'unit': 'mg/dL',
          'ranges': [
            LinearGaugeRange(startValue: 70, endValue: 99, color: Colors.green),
            LinearGaugeRange(startValue: 100, endValue: 125, color: Colors.yellow),
            LinearGaugeRange(startValue: 126, endValue: 200, color: Colors.red),
          ],
        },
      if (widget.hba1c != null)
        {
          'type': 'gauge',
          'label': 'HbA1c',
          'value': widget.hba1c!,
          'unit': '%',
          'ranges': [
            LinearGaugeRange(startValue: 4, endValue: 5.6, color: Colors.green),
            LinearGaugeRange(startValue: 5.7, endValue: 6.4, color: Colors.yellow),
            LinearGaugeRange(startValue: 6.5, endValue: 10, color: Colors.red),
          ],
        },
            if (widget.bmi != null)
        {
          'type': 'gauge',
          'label': 'BMI',
          'value': widget.bmi!,
          'unit': '',
          'ranges': [
            LinearGaugeRange(startValue: 10, endValue: 18.5, color: Colors.blue),
            LinearGaugeRange(startValue: 18.5, endValue: 24.9, color: Colors.green),
            LinearGaugeRange(startValue: 25, endValue: 29.9, color: Colors.yellow),
            LinearGaugeRange(startValue: 30, endValue: 40, color: Colors.red),
          ],
        },
      if (widget.oxygenSaturation != null)
        {
          'type': 'gauge',
          'label': 'Oxygen Saturation',
          'value': widget.oxygenSaturation!.toDouble(),
          'unit': '%',
          'ranges': [
            LinearGaugeRange(startValue: 90, endValue: 95, color: Colors.yellow),
            LinearGaugeRange(startValue: 95, endValue: 100, color: Colors.green),
          ],
        },
      if (widget.bodyTemperature != null)
        {
          'type': 'gauge',
          'label': 'Body Temperature',
          'value': widget.bodyTemperature!,
          'unit': '°C',
          'ranges': [
            LinearGaugeRange(startValue: 35, endValue: 37.5, color: Colors.green),
            LinearGaugeRange(startValue: 37.5, endValue: 38.5, color: Colors.yellow),
            LinearGaugeRange(startValue: 38.5, endValue: 42, color: Colors.red),
          ],
        },
      if (widget.respiratoryRate != null)
        {
          'type': 'gauge',
          'label': 'Respiratory Rate',
          'value': widget.respiratoryRate!.toDouble(),
          'unit': 'breaths/min',
          'ranges': [
            LinearGaugeRange(startValue: 12, endValue: 20, color: Colors.green),
            LinearGaugeRange(startValue: 20, endValue: 30, color: Colors.yellow),
            LinearGaugeRange(startValue: 30, endValue: 50, color: Colors.red),
          ],
        },
      if (widget.waistToHipRatio != null)
        {
          'type': 'gauge',
          'label': 'Waist to Hip Ratio',
          'value': widget.waistToHipRatio!,
          'unit': '',
          'ranges': [
            LinearGaugeRange(startValue: 0, endValue: 0.85, color: Colors.green),
            LinearGaugeRange(startValue: 0.85, endValue: 1.0, color: Colors.yellow),
            LinearGaugeRange(startValue: 1.0, endValue: 2.0, color: Colors.red),
          ],
        },
      if (widget.bodyFatPercentage != null)
        {
          'type': 'gauge',
          'label': 'Body Fat Percentage',
          'value': widget.bodyFatPercentage!,
          'unit': '%',
          'ranges': [
            LinearGaugeRange(startValue: 10, endValue: 20, color: Colors.green),
            LinearGaugeRange(startValue: 20, endValue: 25, color: Colors.yellow),
            LinearGaugeRange(startValue: 25, endValue: 40, color: Colors.red),
          ],
        },
      if (widget.muscleMass != null)
        {
          'type': 'text',
          'label': 'Muscle Mass',
          'value': '${widget.muscleMass} kg',
          'color': Colors.orange,
        },
      if (widget.boneDensity != null)
        {
          'type': 'text',
          'label': 'Bone Density',
          'value': '${widget.boneDensity} g/cm²',
          'color': Colors.teal,
        },
      if (widget.basalMetabolicRate != null)
        {
          'type': 'text',
          'label': 'Basal Metabolic Rate',
          'value': '${widget.basalMetabolicRate} kcal/day',
          'color': Colors.purple,
        },
      if (widget.vo2Max != null)
        {
          'type': 'gauge',
          'label': 'VO2 Max',
          'value': widget.vo2Max!,
          'unit': 'mL/kg/min',
          'ranges': [
            LinearGaugeRange(startValue: 20, endValue: 40, color: Colors.yellow),
            LinearGaugeRange(startValue: 40, endValue: 60, color: Colors.green),
            LinearGaugeRange(startValue: 60, endValue: 80, color: Colors.blue),
          ],
        }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = healthData
        .where((item) => item['label'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 600, maxWidth: 800),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (filteredData.isEmpty)
                Center(
                  child: Text(
                    'Add your first record.',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                      if (item['type'] == 'text') {
                        return Padding(padding: 
EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextInfo(
                              label: item['label'],
                              value: item['value'],
                            ),
                          ),
                        )
                      
                        );
                        
                      } else if (item['type'] == 'gauge') {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox()
      ),
    ),
  );
}
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}