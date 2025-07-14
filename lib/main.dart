import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'models/goal.dart';
import 'services/goal_service.dart';
import 'services/font_service.dart';
import 'features/goals/goal_form.dart';
import 'features/goals/goal_list.dart';
import 'widgets/add_saving_dialog.dart';
import 'screens/about_screen.dart';

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
  int _selectedIndex = 0; // 0: All, 1: On Progress, 2: Completed

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

  List<Goal> get _filteredGoals {
    switch (_selectedIndex) {
      case 1: // On Progress
        return _goals.where((goal) => goal.progress < 1.0).toList();
      case 2: // Completed
        return _goals.where((goal) => goal.progress >= 1.0).toList();
      default: // All
        return _goals;
    }
  }

  String get _currentFilterType {
    switch (_selectedIndex) {
      case 1:
        return 'progress';
      case 2:
        return 'completed';
      default:
        return 'all';
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        title: const Text('Hapus Dream? 🥺'),
        content: Text('Yakin nih mau hapus dream "${goal.name}"? Sayang loh!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Nggak jadi'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _goals.removeWhere((g) => g.id == goal.id);
              });
              _saveGoals();
              Navigator.pop(context);
            },
            child: const Text('Yauda hapus aja'),
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

  void _quickAddSaving(Goal goal, int amount) {
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

    // Show a snackbar to confirm the action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mantap! +${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(amount)} ke ${goal.name} 🎉',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white70),
                    SizedBox(width: 12),
                    Text('Info App'),
                  ],
                ),
              ),
            ],
            color: const Color(0xFF2C2C4E),
          ),
        ],
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
                    goals: _filteredGoals,
                    onEdit: _editGoal,
                    onDelete: _deleteGoal,
                    onAddSaving: _addSaving,
                    onQuickAddSaving: _quickAddSaving,
                    filterType: _currentFilterType,
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2C2C4E), Color(0xFF1C1C2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.white.withValues(alpha: 0.6),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              activeIcon: Icon(Icons.list_alt, size: 28),
              label: 'Semua',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              activeIcon: Icon(Icons.trending_up, size: 28),
              label: 'Progres',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              activeIcon: Icon(Icons.check_circle, size: 28),
              label: 'Selesai',
            ),
          ],
        ),
      ),
    );
  }
}
