enum SubscriptionType { monthly, yearly }

class Subscription {
  final SubscriptionType type;
  final double price;
  final double? oldPrice;
  final String description;

  const Subscription({
    required this.type,
    this.oldPrice,
    required this.price,
    required this.description,
  });

  static const monthly = Subscription(
    type: SubscriptionType.monthly,
    oldPrice: 0,
    price: 9.99,
    description: 'Месячная подписка',
  );

  static const yearly = Subscription(
    type: SubscriptionType.yearly,
    oldPrice: 103.99,
    price: 79.99,
    description: 'Годовая подписка (скидка 33%)',
  );

  String get displayPrice => '\$${price.toStringAsFixed(2)}';
  String get displayOldPrice => '\$${oldPrice!.toStringAsFixed(2)}';
  String get period => type == SubscriptionType.monthly ? 'в месяц' : 'в год';
}
