import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../models/goal.dart';
import '../../screens/goal_detail_screen.dart';

class GoalList extends StatelessWidget {
  final List<Goal> goals;
  final void Function(Goal) onEdit;
  final void Function(Goal) onDelete;
  final void Function(Goal) onAddSaving;
  final void Function(Goal, int, {bool showSnackbar}) onQuickAddSaving;
  final String filterType; // 'all', 'progress', 'completed'

  const GoalList({
    super.key,
    required this.goals,
    required this.onEdit,
    required this.onDelete,
    required this.onAddSaving,
    required this.onQuickAddSaving,
    this.filterType = 'all',
  });

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return _buildEmptyState(context, filterType);
    }
    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, i) {
        final goal = goals[i];
        final isCompleted = goal.progress >= 1.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      GoalDetailScreen(
                        goal: goal,
                        onEdit: onEdit,
                        onDelete: onDelete,
                        onAddSaving: (goal, amount) {
                          // Call from detail screen - don't show snackbar in main
                          onQuickAddSaving(goal, amount, showSnackbar: false);
                        },
                      ),
                  transitionDuration: const Duration(milliseconds: 600),
                  reverseTransitionDuration: const Duration(milliseconds: 400),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                ),
              );
            },
            child: Hero(
              tag: 'goal-card-${goal.id}',
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.green.withValues(alpha: 0.2)
                                : Theme.of(
                                    context,
                                  ).colorScheme.surface.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isCompleted
                                  ? Colors.green.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.2),
                              width: isCompleted ? 2 : 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Celebration banner for completed goals
                                if (isCompleted) ...[
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 12,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.amber.withValues(alpha: 0.8),
                                          Colors.orange.withValues(alpha: 0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.celebration,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            'Goal Tercapai! 🎯✨',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: goal.imagePath != null
                                              ? Image.file(
                                                  File(goal.imagePath!),
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.surface,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.image_outlined,
                                                    size: 30,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                ),
                                        ),
                                        // Achievement badge for completed goals
                                        if (isCompleted)
                                          Positioned(
                                            top: -5,
                                            right: -5,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  goal.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    decoration: isCompleted
                                                        ? TextDecoration.none
                                                        : null,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Budget: ${NumberFormat.currency(locale: 'id', symbol: 'Rp').format(goal.targetPrice)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') onEdit(goal);
                                        if (value == 'delete') onDelete(goal);
                                        if (value == 'add') onAddSaving(goal);
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Hapus'),
                                        ),
                                      ],
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Progress: ${(goal.progress * 100).toStringAsFixed(1)}%',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isCompleted
                                                    ? Colors.green.shade300
                                                    : Colors.white.withValues(
                                                        alpha: 0.8,
                                                      ),
                                                fontWeight: isCompleted
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isCompleted) ...[
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.emoji_events,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp',
                                        ).format(goal.savedSoFar),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isCompleted
                                              ? Colors.green.shade300
                                              : Colors.white,
                                        ),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: goal.progress,
                                    minHeight: 12,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    color: isCompleted
                                        ? Colors.green.shade400
                                        : Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      isCompleted
                                          ? Icons.check_circle
                                          : Icons.calendar_today,
                                      size: 16,
                                      color: isCompleted
                                          ? Colors.green.shade300
                                          : Colors.white.withValues(alpha: 0.7),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        isCompleted
                                            ? 'Udah kelar nih! 🎯'
                                            : 'Estimasi kelar: ${DateFormat('dd MMM yyyy', 'id').format(goal.estimatedFinishDate)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: isCompleted
                                              ? Colors.green.shade300
                                              : Colors.white.withValues(
                                                  alpha: 0.7,
                                                ),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Quick Action Buttons (hide for completed goals)
                                if (!isCompleted)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () => onQuickAddSaving(
                                            goal,
                                            goal.savingAmount,
                                            showSnackbar: true,
                                          ),
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                            size: 18,
                                          ),
                                          label: Text(
                                            '${goal.savingPeriod == 'daily'
                                                ? 'Harian'
                                                : goal.savingPeriod == 'weekly'
                                                ? 'Mingguan'
                                                : 'Bulanan'}: ${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(goal.savingAmount)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withValues(alpha: 0.8),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        onPressed: () => onAddSaving(goal),
                                        icon: const Icon(Icons.edit, size: 18),
                                        label: const Text(
                                          'Nabung',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.8),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                // Celebration message for completed goals
                                if (isCompleted)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.green.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "🌟 Keren banget! Mimpi kamu udah tercapai nih! Waktunya nikmatin hasil jerih payah atau bikin goal baru lagi! 💪✨",
                                      style: TextStyle(
                                        color: Colors.green.shade300,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Floating sparkle effects for completed goals
                    if (isCompleted) ...[
                      Positioned(
                        top: 10,
                        right: 20,
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.amber.withValues(alpha: 0.8),
                          size: 24,
                        ),
                      ),
                      Positioned(
                        top: 30,
                        right: 50,
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.yellow.withValues(alpha: 0.6),
                          size: 16,
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.orange.withValues(alpha: 0.7),
                          size: 20,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildEmptyState(BuildContext context, String filterType) {
  String title;
  String subtitle;
  IconData icon;

  switch (filterType) {
    case 'progress':
      title = 'Belum Ada yang On Progress';
      subtitle =
          'Semua goal udah selesai atau belum mulai nih! Yuk mulai ngimpi!';
      icon = Icons.trending_up;
      break;
    case 'completed':
      title = 'Belum Ada yang Kelar';
      subtitle = 'Tetap semangat! Selesaiin goal pertama dulu ya!';
      icon = Icons.check_circle;
      break;
    default:
      title = 'Belum Ngimpi Nih!';
      subtitle = 'Yuk ngimpi dan mulai nabung buat wujudin!';
      icon = Icons.rocket_launch;
  }

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 100, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
