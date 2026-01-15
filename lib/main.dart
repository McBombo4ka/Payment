import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/subscription_bloc.dart';
import 'bloc/subscription_event.dart';
import 'bloc/subscription_state.dart';
import 'data/subscription_repository.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/paywall_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final repository = SubscriptionRepository(prefs);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final SubscriptionRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionBloc(repository)..add(CheckSubscriptionStatus()),
      child: MaterialApp(
        title: 'Subscription App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is SubscriptionActive) {
          return const HomeScreen();
        }

        if (state is SubscriptionInactive) {
          if (state.hasSeenOnboarding) {
            return const PaywallScreen();
          }
          return const OnboardingScreen();
        }

        return const OnboardingScreen();
      },
    );
  }
}