import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription.dart';

class SubscriptionRepository {
  final SharedPreferences _prefs;

  static const _keyHasSubscription = 'has_subscription';
  static const _keySubscriptionType = 'subscription_type';
  static const _keyHasSeenOnboarding = 'has_seen_onboarding';

  SubscriptionRepository(this._prefs);

  Future<bool> hasActiveSubscription() async {
    return _prefs.getBool(_keyHasSubscription) ?? false;
  }

  Future<SubscriptionType?> getSubscriptionType() async {
    final typeStr = _prefs.getString(_keySubscriptionType);
    if (typeStr == null) return null;
    return SubscriptionType.values.firstWhere(
      (e) => e.toString() == typeStr,
      orElse: () => SubscriptionType.monthly,
    );
  }

  Future<void> activateSubscription(SubscriptionType type) async {
    await _prefs.setBool(_keyHasSubscription, true);
    await _prefs.setString(_keySubscriptionType, type.toString());
  }

  Future<void> markOnboardingComplete() async {
    await _prefs.setBool(_keyHasSeenOnboarding, true);
  }

  Future<bool> hasSeenOnboarding() async {
    return _prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }

  Future<void> reset() async {
    await _prefs.clear();
  }
}