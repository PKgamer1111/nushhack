import 'package:flutter/material.dart';
import 'package:nushhack/widgets/information_card.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // GlobalKey to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double healthScore = 85.0;

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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open the drawer using the GlobalKey
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
            // Circular Gauge displaying the dummy health score
            Center(
              child: SizedBox(
                height: 200,
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
            const SizedBox(height: 16),

            // Left-aligned Health Status title
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Health Status',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

            // InformationList Widget
            Expanded(
              child: InformationList(
                bloodPressure: '120/80',
                heartRate: 72,
                cholesterol: 180,
                glucoseLevel: 100,
                bmi: 22.5,
                condition: 'Healthy',
                oxygenSaturation: 98,
                bodyTemperature: 36.7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer implementation
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
                  title: const Text('Guide'),
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