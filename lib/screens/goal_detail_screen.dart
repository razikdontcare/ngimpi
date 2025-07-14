import 'dart:io';
import 'dart:math' show cos, sin;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/goal.dart';
import '../widgets/add_saving_dialog.dart';

class GoalDetailScreen extends StatefulWidget {
  final Goal goal;
  final void Function(Goal)? onEdit;
  final void Function(Goal)? onDelete;
  final void Function(Goal, int)? onAddSaving;

  const GoalDetailScreen({
    super.key,
    required this.goal,
    this.onEdit,
    this.onDelete,
    this.onAddSaving,
  });

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  late AnimationController _celebrationController;
  late Animation<double> _celebrationAnimation;
  late AnimationController _contentAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Progress animation
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: widget.goal.progress)
        .animate(
          CurvedAnimation(
            parent: _progressAnimationController,
            curve: Curves.easeOutQuart,
          ),
        );

    // Celebration animation for completed goals
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _celebrationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _celebrationController, curve: Curves.elasticOut),
    );

    // Content slide and fade animations
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _progressAnimationController.forward();
    _contentAnimationController.forward();
    if (widget.goal.progress >= 1.0) {
      Future.delayed(const Duration(milliseconds: 800), () {
        _celebrationController.forward();
      });
    }
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _celebrationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _addSaving() {
    if (widget.onAddSaving != null) {
      showDialog(
        context: context,
        builder: (ctx) => AddSavingDialog(
          goal: widget.goal,
          onAdd: (amount) {
            widget.onAddSaving!(widget.goal, amount);

            // Only update progress animation without restarting other animations
            _progressAnimation =
                Tween<double>(
                  begin: _progressAnimation.value,
                  end: widget.goal.progress,
                ).animate(
                  CurvedAnimation(
                    parent: _progressAnimationController,
                    curve: Curves.easeOutQuart,
                  ),
                );
            _progressAnimationController.reset();
            _progressAnimationController.forward();

            // Start celebration if goal is completed
            if (widget.goal.progress >= 1.0) {
              Future.delayed(const Duration(milliseconds: 800), () {
                _celebrationController.forward();
              });
            }

            // Show success snackbar in detail screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Mantap! +${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(amount)} ditambahkan! 🎉',
                ),
                duration: const Duration(seconds: 2),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            );

            // Trigger a minimal setState to update the UI
            setState(() {});
          },
        ),
      );
    }
  }

  void _quickAddSaving(int amount) {
    if (widget.onAddSaving != null) {
      // Call the parent callback which will handle the update and save
      widget.onAddSaving!(widget.goal, amount);

      // Only update progress animation without restarting other animations
      _progressAnimation =
          Tween<double>(
            begin: _progressAnimation.value,
            end: widget.goal.progress,
          ).animate(
            CurvedAnimation(
              parent: _progressAnimationController,
              curve: Curves.easeOutQuart,
            ),
          );
      _progressAnimationController.reset();
      _progressAnimationController.forward();

      // Start celebration if goal is completed
      if (widget.goal.progress >= 1.0) {
        Future.delayed(const Duration(milliseconds: 800), () {
          _celebrationController.forward();
        });
      }

      // Show success snackbar in detail screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mantap! +${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(amount)} ditambahkan! 🎉',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );

      // Trigger a minimal setState to update the UI
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.goal.progress >= 1.0;
    final remaining = widget.goal.targetPrice - widget.goal.savedSoFar;
    final progressPercentage = (widget.goal.progress * 100);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2E),
      body: Hero(
        tag: 'goal-card-${widget.goal.id}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1C1C2E), Color(0xFF2C2C4E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CustomScrollView(
              slivers: [
                // App Bar with Image
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background Image
                        widget.goal.imagePath != null
                            ? Image.file(
                                File(widget.goal.imagePath!),
                                fit: BoxFit.cover,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Icon(
                                  Icons.photo_outlined,
                                  size: 100,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // Celebration sparkles for completed goals
                        if (isCompleted)
                          AnimatedBuilder(
                            animation: _celebrationAnimation,
                            builder: (context, child) {
                              return Positioned.fill(
                                child: CustomPaint(
                                  painter: SparklesPainter(
                                    _celebrationAnimation.value,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit' && widget.onEdit != null) {
                          widget.onEdit!(widget.goal);
                        }
                        if (value == 'delete' && widget.onDelete != null) {
                          widget.onDelete!(widget.goal);
                          Navigator.pop(context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.white70),
                              SizedBox(width: 12),
                              Text('Edit Goal'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 12),
                              Text('Hapus Goal'),
                            ],
                          ),
                        ),
                      ],
                      color: const Color(0xFF2C2C4E),
                    ),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Goal Name and Completion Badge
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.goal.name,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (isCompleted)
                                  AnimatedBuilder(
                                    animation: _celebrationAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _celebrationAnimation.value,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.amber.withValues(
                                                  alpha: 0.5,
                                                ),
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.emoji_events,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Target Price
                            Text(
                              'Target: ${NumberFormat.currency(locale: 'id', symbol: 'Rp').format(widget.goal.targetPrice)}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Completion Banner
                            if (isCompleted)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.withValues(alpha: 0.8),
                                      Colors.teal.withValues(alpha: 0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.celebration,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Goal Tercapai! 🎯✨',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Selamat! Mimpi kamu udah jadi kenyataan nih!',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                            // Progress Section
                            _buildProgressSection(
                              progressPercentage,
                              isCompleted,
                            ),

                            const SizedBox(height: 24),

                            // Statistics Cards
                            _buildStatisticsSection(remaining, isCompleted),

                            const SizedBox(height: 24),

                            // Saving Plan Section
                            _buildSavingPlanSection(),

                            const SizedBox(height: 24),

                            // Action Buttons
                            if (!isCompleted) _buildActionButtons(),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(double progressPercentage, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C4E).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Text(
                    '${(_progressAnimation.value * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.green.shade300 : Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: _progressAnimation.value,
                  minHeight: 16,
                  backgroundColor: const Color(0xFF1C1C2E),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted
                        ? Colors.green.shade400
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Terkumpul:',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  NumberFormat.currency(
                    locale: 'id',
                    symbol: 'Rp',
                  ).format(widget.goal.savedSoFar),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.green.shade300 : Colors.white,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(int remaining, bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistik',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Sisa Target',
                value: isCompleted
                    ? 'Selesai! 🎉'
                    : NumberFormat.currency(
                        locale: 'id',
                        symbol: 'Rp',
                        decimalDigits: 0,
                      ).format(remaining),
                icon: isCompleted ? Icons.check_circle : Icons.savings,
                color: isCompleted ? Colors.green : Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Mulai Nabung',
                value: DateFormat(
                  'dd MMM yyyy',
                  'id',
                ).format(widget.goal.startDate),
                icon: Icons.calendar_today,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Target Selesai',
                value: isCompleted
                    ? 'Udah kelar! 🏆'
                    : DateFormat(
                        'dd MMM yyyy',
                        'id',
                      ).format(widget.goal.estimatedFinishDate),
                icon: isCompleted ? Icons.emoji_events : Icons.flag,
                color: isCompleted ? Colors.amber : Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Periode Nabung',
                value: widget.goal.savingPeriod == 'daily'
                    ? 'Harian'
                    : widget.goal.savingPeriod == 'weekly'
                    ? 'Mingguan'
                    : 'Bulanan',
                icon: Icons.schedule,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildSavingPlanSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C4E).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Rencana Nabung',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nominal ${widget.goal.savingPeriod == 'daily'
                    ? 'Harian'
                    : widget.goal.savingPeriod == 'weekly'
                    ? 'Mingguan'
                    : 'Bulanan'}:',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
              ),
              Text(
                NumberFormat.currency(
                  locale: 'id',
                  symbol: 'Rp',
                  decimalDigits: 0,
                ).format(widget.goal.savingAmount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (widget.goal.progress < 1.0) ...[
            Divider(color: Colors.white.withValues(alpha: 0.2)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Sisa Target:',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    NumberFormat.currency(
                      locale: 'id',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(widget.goal.targetPrice - widget.goal.savedSoFar),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Quick Add Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _quickAddSaving(widget.goal.savingAmount),
            icon: const Icon(Icons.add_circle_outline, size: 24),
            label: Text(
              'Nabung ${widget.goal.savingPeriod == 'daily'
                  ? 'Harian'
                  : widget.goal.savingPeriod == 'weekly'
                  ? 'Mingguan'
                  : 'Bulanan'} (${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(widget.goal.savingAmount)})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Custom Amount Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _addSaving,
            icon: const Icon(Icons.edit, size: 20),
            label: const Text(
              'Nabung Jumlah Lain',
              style: TextStyle(fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for sparkle effects
class SparklesPainter extends CustomPainter {
  final double progress;

  SparklesPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withValues(alpha: progress * 0.8)
      ..style = PaintingStyle.fill;

    // Draw multiple sparkles at different positions
    final sparklePositions = [
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.9, size.height * 0.1),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.2, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.6),
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.9),
    ];

    for (int i = 0; i < sparklePositions.length; i++) {
      final position = sparklePositions[i];
      final sparkleSize = (8 + i * 2) * progress;

      // Draw star shape
      _drawStar(canvas, paint, position, sparkleSize);
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    final double radius = size;
    final double innerRadius = radius * 0.4;

    for (int i = 0; i < 10; i++) {
      final angle = (i * 36) * (3.14159 / 180);
      final currentRadius = i.isEven ? radius : innerRadius;
      final x = center.dx + currentRadius * cos(angle);
      final y = center.dy + currentRadius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SparklesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
