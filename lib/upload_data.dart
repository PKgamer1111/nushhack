import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:nushhack/models/indicator.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseUploader {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> uploadIndicators() async {
    try {
      // Get the path to the JSON file
      final String jsonString = await rootBundle.loadString('assets/health_indicators.json');
      final jsonData = jsonDecode(jsonString);

      // Check if the JSON data is valid
      if (jsonData == null || !jsonData.containsKey('indicators')) {
        print("Invalid JSON data");
        return;
      }

      // Parse the JSON data into a list of Indicator objects
      List<dynamic> indicatorsList = jsonData['indicators'];
      List<Indicator> indicators = indicatorsList
          .map((indicatorJson) => Indicator.fromJSON(indicatorJson))
          .toList();

      // Upload each Indicator to Firestore
      for (var indicator in indicators) {
        await uploadIndicator(indicator);
      }

      print("All data uploaded successfully!");
    } catch (e) {
      print("Error uploading data: $e");
    }
  }

  Future<void> uploadIndicator(Indicator indicator) async {
    try {
      // Reference to the Firestore document
      DocumentReference indicatorRef = firestore.collection('indicators').doc(indicator.name);

      // Upload the main indicator data
      await indicatorRef.set(indicator.toFirestore());
    } catch (e) {
      print("Failed to upload indicator ${indicator.name}: $e");
    }
  }
}
