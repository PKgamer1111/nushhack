import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nushhack/guidance.dart';
import 'package:nushhack/indicator_page.dart';
import 'package:nushhack/interpret.dart';
import 'package:nushhack/models/indicator.dart';
import 'package:nushhack/widgets/gauge_indicator.dart';
import 'package:nushhack/widgets/text_info.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'viewmodel.dart'; // Ensure this is correctly imported

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String? selectedMeasure;
  final TextEditingController valueController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<Viewmodel>(context);
    final List<Indicator> indicators = viewModel.list;
    double healthScore = 200-(200/(1+exp(-getAverageLatestZScore(indicators))));
    if (indicators.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<String> measures = indicators.map((i) => i.name).toList();
    selectedMeasure ??= measures.first;

    Color gaugeColor;
    if (healthScore >= 80) {
      gaugeColor = Colors.green;
    } else if (healthScore >= 60) {
      gaugeColor = Colors.yellow.shade800;
    } else {
      gaugeColor = Colors.red;
    }

    final filteredData = searchQuery=='' ? indicators : indicators.where((indicator) {
      return indicator.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

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
      drawer: buildDrawer(getIndicatorsSummary(indicators)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Score',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Card(
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
            const SizedBox(height: 16),
            Text(
              'Health Status',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Expanded(
              child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600, maxWidth: 800),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
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
                              final item = indicators[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle the click event here
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IndicatorPage(indicator: item),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Displaying the indicator name and its latest value
                                          Text(
                                            "${item.name}: ${item.values.last.value.toStringAsFixed(2)} ${item.units}",
                                          ),
                                          const SizedBox(height: 16),
                                          // Displaying the GaugeIndicator for the indicator's Z-score
                                          GaugeIndicator(indicator: item),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            )
          ]
        ),
      ),
      floatingActionButton: buildFloatingActionButton(context, measures),
    );
  }

  double getAverageLatestZScore(List<Indicator> indicators) {
    // Filter out indicators with no values or invalid Z-Scores (e.g., NaN)
    List<double> validZScores = indicators
        .where((indicator) => indicator.values.isNotEmpty && !indicator.latestZScore.isNaN)
        .map((indicator) => indicator.latestZScore.abs())
        .toList();

    if (validZScores.isEmpty) return 0.0;

    // Calculate the sum of all valid Z-Scores
    double sum = validZScores.reduce((a, b) => a + b);

    // Calculate the average
    print(sum / validZScores.length);
    return sum / validZScores.length;
  }

  Widget buildFloatingActionButton(BuildContext context, List<String> measures) {
    return FloatingActionButton.extended(
      label: const Text('Add Record'),
      icon: const Icon(Icons.add),
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      onPressed: () => showAddRecordDialog(context, measures),
    );
  }

  void showAddRecordDialog(BuildContext context, List<String> measures) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add New Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedMeasure,
                items: measures.map((measure) {
                  return DropdownMenuItem<String>(
                    value: measure,
                    child: Text(measure),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMeasure = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Measure',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String getIndicatorsSummary(List<Indicator> indicators) {
    // Filter out indicators that have no values or invalid Z-Scores
    List<String> indicatorStrings = indicators
        .where((indicator) => indicator.values.isNotEmpty && !indicator.latestZScore.isNaN)
        .map((indicator) {
          double zScore = indicator.latestZScore;
          return "${indicator.name}: ${zScore.toStringAsFixed(2)}";
        })
        .toList();

    // Join the list into a single string separated by commas
    return indicatorStrings.join(', ');
  }

  Drawer buildDrawer(String req) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
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
          // Guide Button
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Guide'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuidancePage(req: req, type: 1),
                ),
              );
            },
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InterpretPage(),
                ),
              );
            },
          ),
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
