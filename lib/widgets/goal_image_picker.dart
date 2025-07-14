import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GoalImagePicker extends StatefulWidget {
  final String? imagePath;
  final void Function(String?) onImageSelected;
  const GoalImagePicker({
    super.key,
    this.imagePath,
    required this.onImageSelected,
  });

  @override
  State<GoalImagePicker> createState() => _GoalImagePickerState();
}

class _GoalImagePickerState extends State<GoalImagePicker> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
      widget.onImageSelected(_imagePath);
    }
  }

  void _removeImage() {
    setState(() {
      _imagePath = null;
    });
    widget.onImageSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imagePath != null)
          Stack(
            children: [
              Image.file(
                File(_imagePath!),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: _removeImage,
                ),
              ),
            ],
          )
        else
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Pilih Gambar (opsional)'),
          ),
      ],
    );
  }
}
