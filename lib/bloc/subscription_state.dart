import '../models/subscription.dart';

abstract class SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionInactive extends SubscriptionState {
  final bool hasSeenOnboarding;
  SubscriptionInactive({required this.hasSeenOnboarding});
}

class SubscriptionPaymentPending extends SubscriptionState {
  final SubscriptionType selectedType;
  SubscriptionPaymentPending(this.selectedType);
}

class SubscriptionActive extends SubscriptionState {
  final SubscriptionType type;
  SubscriptionActive(this.type);
}

class SubscriptionPurchasing extends SubscriptionState {}

class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);
}