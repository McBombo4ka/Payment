import '../models/subscription.dart';

abstract class SubscriptionEvent {}

class CheckSubscriptionStatus extends SubscriptionEvent {}

class CompleteOnboarding extends SubscriptionEvent {}

class ProceedToPayment extends SubscriptionEvent {
  final SubscriptionType type;
  ProceedToPayment(this.type);
}

class PurchaseSubscription extends SubscriptionEvent {
  final SubscriptionType type;
  final String cardNumber;
  final String expiry;
  final String cvv;

  PurchaseSubscription({
    required this.type,
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
  });
}

class CancelSubscription extends SubscriptionEvent {}