import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

mixin AnalyticsScreenTracker<T extends StatefulWidget> on State<T> {
  String get screenName;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: screenName);
  }
}
