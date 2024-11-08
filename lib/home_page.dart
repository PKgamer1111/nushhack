import 'package:flutter/material.dart';
import 'package:nushhack/widgets/information_card.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double healthScore = 85.0;

  // Dropdown options for measures
  final List<String> measures = [
    'Blood Pressure',
    'Heart Rate',
    'Cholesterol',
    'Glucose Level',
    'BMI',
    'Oxygen Saturation',
    'Body Temperature',
    'Respiratory Rate',
    'Waist Circumference',
    'Hip Circumference',
    'Waist to Hip Ratio',
    'Body Fat Percentage',
    'Muscle Mass',
    'Bone Density',
    'Basal Metabolic Rate',
    'VO2 Max',
  ];

  String selectedMeasure = 'Blood Pressure';
  final TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color gaugeColor;
    if (healthScore >= 80) {
      gaugeColor = Colors.green;
    } else if (healthScore >= 60) {
      gaugeColor = Colors.yellow;
    } else {
      gaugeColor = Colors.red;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('HealthLink'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Overall Score',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                child: Center(
                  child: SizedBox(
                    height: 210,
                    width: 200,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: AxisLineStyle(
                            thickness: 0.2,
                            cornerStyle: CornerStyle.bothCurve,
                            thicknessUnit: GaugeSizeUnit.factor,
                            color: gaugeColor.withOpacity(0.3),
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: healthScore,
                              cornerStyle: CornerStyle.bothCurve,
                              width: 0.2,
                              sizeUnit: GaugeSizeUnit.factor,
                              gradient: SweepGradient(
                                colors: [gaugeColor, gaugeColor.withOpacity(0.5)],
                                stops: const [0.0, 1.0],
                              ),
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                '${healthScore.toStringAsFixed(1)} / 100',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: gaugeColor,
                                    ),
                              ),
                              angle: 90,
                              positionFactor: 0.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Health Status',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: InformationList(
                bloodPressure: '120/80',
                heartRate: 72,
                bmi: 22.5,
                oxygenSaturation: 98,
                bodyTemperature: 36.7,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text('Add Record'),
      icon: const Icon(Icons.add),
      backgroundColor: Colors.blueAccent,
      onPressed: () => showAddRecordDialog(context),
    );
  }

  void showAddRecordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add New Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Measure Dropdown
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
  child: DropdownButtonFormField2<String>(
  buttonStyleData: ButtonStyleData(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  iconStyleData: IconStyleData(
    icon: const Icon(Icons.arrow_forward_ios_outlined),
    iconSize: 16,
    iconEnabledColor: Colors.blueAccent,
    iconDisabledColor: Colors.grey,
  ),
  dropdownStyleData: DropdownStyleData(
    maxHeight: 250,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
    ),
    offset: const Offset(0, -8),
    scrollbarTheme: ScrollbarThemeData(
      radius: const Radius.circular(20),
      thickness: MaterialStateProperty.all<double>(5),
      thumbVisibility: MaterialStateProperty.all<bool>(true),
    ),
  ),
  value: selectedMeasure,
  validator: (value) {
    if (value == null) {
      return 'Please select a measure.';
    }
    return null;
  },
  onChanged: (String? newValue) {
    setState(() {
      selectedMeasure = newValue!;
    });
  },
  decoration: InputDecoration(
    labelText: 'Select Measure',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  items: measures.map((String measure) {
    return DropdownMenuItem<String>(
      value: measure,
      child: Text(measure),
    );
  }).toList(),
)
),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Value Input Field
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Value',
                  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Add functionality will be implemented later
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add functionality will be implemented later
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drawer Header
          Container(
            alignment: Alignment.bottomCenter,
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'HealthLink',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Sign In Button
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Sign In'),
                  onTap: () {
                    // Dummy Sign In action
                  },
                ),
                // Guide Button
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Lifestyle'),
                  onTap: () {},
                ),
                // Predict Button
                ListTile(
                  leading: const Icon(Icons.analytics),
                  title: const Text('Predict'),
                  onTap: () {},
                ),
                // Interpret Button
                ListTile(
                  leading: const Icon(Icons.insights),
                  title: const Text('Interpret'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          // Bottom section of the drawer
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
