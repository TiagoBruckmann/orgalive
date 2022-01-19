import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {

  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  // send currant screen
  Future<void> sendScreen( String screenName ) async {
    await _analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenName,
    );
  }

}