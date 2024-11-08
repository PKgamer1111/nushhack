import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nushhack/models/indicator.dart';
import 'package:nushhack/models/value_entry.dart';

class Viewmodel with ChangeNotifier {
  final List<Indicator> list = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Viewmodel() {
    _loadIndicators();
  }

  Future<void> _loadIndicators() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('indicators').get();
      list.clear();
      for (var doc in snapshot.docs) {
        Indicator indicator = await _loadIndicator(doc);
        list.add(indicator);
      }
      notifyListeners();
    } catch (e) {
      print("Error loading indicators: $e");
    }
  }

  Future<Indicator> _loadIndicator(QueryDocumentSnapshot doc) async {
    Indicator indicator = Indicator.fromFirestore(doc.data() as Map<String, dynamic>);
    return indicator;
  }

}