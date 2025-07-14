import 'package:flutter/material.dart';
import '../models/goal.dart';

class AddSavingDialog extends StatefulWidget {
  final Goal goal;
  final void Function(int) onAdd;

  const AddSavingDialog({super.key, required this.goal, required this.onAdd});

  @override
  State<AddSavingDialog> createState() => _AddSavingDialogState();
}

class _AddSavingDialogState extends State<AddSavingDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text);
    if (value != null && value > 0) {
      widget.onAdd(value);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Tabungan'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Nominal (IDR)'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Tambah')),
      ],
    );
  }
}
