import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/goal_image_picker.dart';
import '../../models/goal.dart';
import '../../services/font_service.dart';

Future<void> showGoalFormBottomSheet(
  BuildContext context, {
  Goal? goal,
  required void Function(Goal) onSave,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: GoalForm(goal: goal, onSave: onSave),
    ),
  );
}

class GoalForm extends StatefulWidget {
  final Goal? goal;
  final void Function(Goal) onSave;

  const GoalForm({super.key, this.goal, required this.onSave});

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _targetController;
  late TextEditingController _savingController;
  String _savingPeriod = 'daily'; // 'daily', 'weekly', 'monthly'
  DateTime _startDate = DateTime.now();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.goal?.name ?? '');
    _targetController = TextEditingController(
      text: widget.goal?.targetPrice.toString() ?? '',
    );
    _savingController = TextEditingController(
      text: widget.goal?.savingAmount.toString() ?? '',
    );
    _savingPeriod = widget.goal?.savingPeriod ?? 'daily';
    _startDate = widget.goal?.startDate ?? DateTime.now();
    _imagePath = widget.goal?.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _savingController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('id'),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final goal = Goal(
        id: widget.goal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        targetPrice: int.parse(_targetController.text),
        savingAmount: int.parse(_savingController.text),
        savingPeriod: _savingPeriod,
        startDate: _startDate,
        savedSoFar: widget.goal?.savedSoFar ?? 0,
        imagePath: _imagePath,
      );
      widget.onSave(goal);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2C2C4E), Color(0xFF1C1C2E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.goal == null ? 'Yuk Ngimpi! ✨' : 'Edit Mimpi Kamu 💫',
                  style: FontService.getSafeTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GoalImagePicker(
                imagePath: _imagePath,
                onImageSelected: (path) => setState(() => _imagePath = path),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Ngimpi apa nih? 🤔',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF9B59B6),
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.emoji_objects_outlined,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Wajib isi ya!' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _targetController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Butuh budget berapa? 💰',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF9B59B6),
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.flag_outlined,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Wajib isi ya!' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _savingController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: _savingPeriod == 'daily'
                      ? 'Nabung per hari 📅'
                      : _savingPeriod == 'weekly'
                      ? 'Nabung per minggu 🗓️'
                      : 'Nabung per bulan 📆',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF9B59B6),
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.savings_outlined,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Wajib isi ya!' : null,
              ),
              const SizedBox(height: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      segmentedButtonTheme: SegmentedButtonThemeData(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return const Color(0xFF9B59B6);
                            }
                            return Colors.white.withValues(alpha: 0.1);
                          }),
                          foregroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            return Colors.white;
                          }),
                          side: WidgetStateProperty.all(
                            const BorderSide(color: Colors.white30),
                          ),
                        ),
                      ),
                    ),
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'daily', label: Text('Hari')),
                        ButtonSegment(value: 'weekly', label: Text('Minggu')),
                        ButtonSegment(value: 'monthly', label: Text('Bulan')),
                      ],
                      selected: {_savingPeriod},
                      onSelectionChanged: (s) =>
                          setState(() => _savingPeriod = s.first),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickDate,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white30),
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.white70,
                    ),
                    label: Flexible(
                      child: Text(
                        'Kapan mau mulai? ${DateFormat('dd MMM yyyy', 'id').format(_startDate)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Nanti deh'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF9B59B6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Gas! 🚀'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
