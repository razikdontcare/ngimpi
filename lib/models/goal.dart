// import 'package:intl/intl.dart';

/// Model untuk tujuan impian pengguna
class Goal {
  String id;
  String name;
  int targetPrice;
  int savingAmount;
  String savingPeriod; // 'daily', 'weekly', 'monthly'
  DateTime startDate;
  int savedSoFar;
  String? imagePath;

  Goal({
    required this.id,
    required this.name,
    required this.targetPrice,
    required this.savingAmount,
    required this.savingPeriod,
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
    final hari = switch (savingPeriod) {
      'daily' => (sisa / savingAmount).ceil(),
      'weekly' => ((sisa / savingAmount).ceil() * 7),
      'monthly' => ((sisa / savingAmount).ceil() * 30),
      _ => (sisa / savingAmount).ceil(),
    };
    return startDate.add(Duration(days: hari));
  }

  // Untuk simpan ke SharedPreferences (sebagai Map)
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'targetPrice': targetPrice,
    'savingAmount': savingAmount,
    'savingPeriod': savingPeriod,
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
    savingPeriod:
        map['savingPeriod'] ?? (map['isDaily'] == true ? 'daily' : 'weekly'),
    startDate: DateTime.parse(map['startDate']),
    savedSoFar: map['savedSoFar'] ?? 0,
    imagePath: map['imagePath'],
  );
}
