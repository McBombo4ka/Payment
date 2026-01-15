import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';
import '../models/subscription.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          BlocBuilder<SubscriptionBloc, SubscriptionState>(
            builder: (context, state) {
              if (state is SubscriptionActive) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    avatar: const Icon(Icons.verified, size: 18),
                    label: Text(
                      state.type == SubscriptionType.yearly
                          ? 'Годовая'
                          : 'Месячная',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.celebration, color: Colors.amber, size: 32),
                      SizedBox(width: 12),
                      Text(
                        'Добро пожаловать!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Теперь у вас есть доступ ко всем премиум функциям',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Премиум контент',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._buildContentItems(),
          const SizedBox(height: 24),

          // КНОПКА СБРОСА ПОДПИСКИ
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 32),
                  const SizedBox(height: 12),
                  const Text(
                    'Тестовая функция',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Сбросить подписку для тестирования',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showResetDialog(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Сбросить подписку'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сбросить подписку?'),
        content: const Text(
          'Это вернёт вас к экрану выбора подписки. Используйте для тестирования.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SubscriptionBloc>().add(CancelSubscription());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContentItems() {
    final items = [
      {
        'icon': Icons.fitness_center,
        'title': 'Тренировки',
        'subtitle': '100+ упражнений',
      },
      {
        'icon': Icons.restaurant,
        'title': 'Питание',
        'subtitle': '50+ рецептов',
      },
      {'icon': Icons.book, 'title': 'Статьи', 'subtitle': 'Экспертные советы'},
      {
        'icon': Icons.video_library,
        'title': 'Видео',
        'subtitle': 'HD качество',
      },
      {
        'icon': Icons.headphones,
        'title': 'Медитации',
        'subtitle': 'Расслабление',
      },
    ];

    return items
        .map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(child: Icon(item['icon'] as IconData)),
              title: Text(
                item['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['subtitle'] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        )
        .toList();
  }
}
