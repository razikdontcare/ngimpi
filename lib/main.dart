import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/goal.dart';
import 'services/goal_service.dart';
import 'services/font_service.dart';
import 'features/goals/goal_form.dart';
import 'features/goals/goal_list.dart';
import 'widgets/add_saving_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeDateFormatting('id', null);
  } catch (e) {
    print('Error initializing date formatting: $e');
  }

  runApp(const NgimpiApp());
}

class NgimpiApp extends StatelessWidget {
  const NgimpiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngimpi',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('id'), // Indonesian
      ],
      locale: const Locale('id'), // Set Indonesian as default
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF9B59B6),
        scaffoldBackgroundColor: const Color(0xFF1C1C2E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF9B59B6),
          secondary: Color(0xFFF39C12),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          surface: Color(0xFF2C2C4E),
          onSurface: Colors.white,
        ),
        useMaterial3: true,
        textTheme: FontService.getSafeTextTheme(context),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoalService _service = GoalService();
  List<Goal> _goals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    setState(() => _loading = true);
    final goals = await _service.getGoals();
    setState(() {
      _goals = goals;
      _loading = false;
    });
  }

  Future<void> _saveGoals() async {
    await _service.saveGoals(_goals);
    setState(() {});
  }

  void _addGoal() {
    showGoalFormBottomSheet(
      context,
      onSave: (goal) {
        setState(() {
          _goals.add(goal);
        });
        _saveGoals();
      },
    );
  }

  void _editGoal(Goal goal) {
    showGoalFormBottomSheet(
      context,
      goal: goal,
      onSave: (edited) {
        setState(() {
          final idx = _goals.indexWhere((g) => g.id == goal.id);
          if (idx != -1) _goals[idx] = edited;
        });
        _saveGoals();
      },
    );
  }

  void _deleteGoal(Goal goal) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Impian'),
        content: Text('Yakin ingin menghapus impian "${goal.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _goals.removeWhere((g) => g.id == goal.id);
              });
              _saveGoals();
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _addSaving(Goal goal) {
    showDialog(
      context: context,
      builder: (ctx) => AddSavingDialog(
        goal: goal,
        onAdd: (amount) {
          setState(() {
            final idx = _goals.indexWhere((g) => g.id == goal.id);
            if (idx != -1) {
              _goals[idx].savedSoFar += amount;
              if (_goals[idx].savedSoFar > _goals[idx].targetPrice) {
                _goals[idx].savedSoFar = _goals[idx].targetPrice;
              }
            }
          });
          _saveGoals();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ngimpi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C2E), Color(0xFF2C2C4E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GoalList(
                    goals: _goals,
                    onEdit: _editGoal,
                    onDelete: _deleteGoal,
                    onAddSaving: _addSaving,
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
