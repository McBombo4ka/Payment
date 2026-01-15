import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/subscription_repository.dart';
import '../models/subscription.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _repository;

  SubscriptionBloc(this._repository) : super(SubscriptionLoading()) {
    on<CheckSubscriptionStatus>(_onCheckStatus);
    on<CompleteOnboarding>(_onCompleteOnboarding);
    on<ProceedToPayment>(_onProceedToPayment);
    on<PurchaseSubscription>(_onPurchase);
    on<CancelSubscription>(_onCancel);
  }

  Future<void> _onCheckStatus(
    CheckSubscriptionStatus event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());

    final hasSubscription = await _repository.hasActiveSubscription();

    if (hasSubscription) {
      final type = await _repository.getSubscriptionType();
      emit(SubscriptionActive(type ?? SubscriptionType.monthly));
    } else {
      final hasSeenOnboarding = await _repository.hasSeenOnboarding();
      emit(SubscriptionInactive(hasSeenOnboarding: hasSeenOnboarding));
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<SubscriptionState> emit,
  ) async {
    await _repository.markOnboardingComplete();
    emit(SubscriptionInactive(hasSeenOnboarding: true));
  }

  Future<void> _onProceedToPayment(
    ProceedToPayment event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionPaymentPending(event.type));
  }

  Future<void> _onPurchase(
    PurchaseSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionPurchasing());

    // Эмуляция обработки платежа
    await Future.delayed(const Duration(seconds: 2));

    // Простая валидация карты (для MVP)
    if (event.cardNumber.length < 16) {
      emit(SubscriptionError('Неверный номер карты'));
      await Future.delayed(const Duration(seconds: 2));
      emit(SubscriptionPaymentPending(event.type));
      return;
    }

    await _repository.activateSubscription(event.type);
    emit(SubscriptionActive(event.type));
  }

  Future<void> _onCancel(
    CancelSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    await _repository.reset();
    emit(SubscriptionInactive(hasSeenOnboarding: true));
  }
}