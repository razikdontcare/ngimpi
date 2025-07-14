// import 'package:intl/intl.dart';

/// Model untuk tujuan impian pengguna
class Goal {
  String id;
  String name;
  int targetPrice;
  int savingAmount;
  bool isDaily; // true = harian, false = mingguan
  DateTime startDate;
  int savedSoFar;
  String? imagePath;

  Goal({
    required this.id,
    required this.name,
    required this.targetPrice,
    required this.savingAmount,
    required this.isDaily,
    required this.startDate,
    this.savedSoFar = 0,
    this.imagePath,
  });

  // Hitung progress dalam persen
  double get progress => (savedSoFar / targetPrice).clamp(0, 1);

  // Hitung estimasi tanggal selesai
  DateTime get estimatedFinishDate {
    if (savingAmount <= 0) return startDate;
    final sisa = targetPrice - savedSoFar;
    final hari = isDaily
        ? (sisa / savingAmount).ceil()
        : ((sisa / savingAmount).ceil() * 7);
    return startDate.add(Duration(days: hari));
  }

  // Untuk simpan ke SharedPreferences (sebagai Map)
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'targetPrice': targetPrice,
    'savingAmount': savingAmount,
    'isDaily': isDaily,
    'startDate': startDate.toIso8601String(),
    'savedSoFar': savedSoFar,
    'imagePath': imagePath,
  };

  // Untuk load dari Map
  factory Goal.fromMap(Map<String, dynamic> map) => Goal(
    id: map['id'],
    name: map['name'],
    targetPrice: map['targetPrice'],
    savingAmount: map['savingAmount'],
    isDaily: map['isDaily'],
    startDate: DateTime.parse(map['startDate']),
    savedSoFar: map['savedSoFar'] ?? 0,
    imagePath: map['imagePath'],
  );
}
