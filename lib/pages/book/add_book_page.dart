import 'package:book_tracker_v9/db/app_db.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

class BookFormPage extends StatefulWidget {
  const BookFormPage({super.key});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final db = AppDatabase.instance;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newBook = BookTrackerCompanion(
        title: drift.Value(_titleController.text),
        author: drift.Value(_authorController.text),
        description: drift.Value(_descriptionController.text),
        imageUrl: drift.Value(_imageUrlController.text),
      );

      try {
        await db.bookTrackerDao.insertBook(newBook);
        if (!mounted) return;
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Book is ready!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(newBook);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        title: const Text('Add New Book'),
        titleTextStyle: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_imageUrlController.text.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _imageUrlController.text,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    )
                  else
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade800,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'No Image',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: _titleController,
                    label: 'Book Title',
                    validator:
                        (v) => v == null || v.isEmpty ? 'Enter title' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _authorController,
                    label: 'Author',
                    validator:
                        (v) => v == null || v.isEmpty ? 'Enter author' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 3,
                    validator:
                        (v) =>
                            v == null || v.isEmpty ? 'Enter description' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _imageUrlController,
                    label: 'Image URL',
                    hint: 'https://example.com/image.jpg',
                    onChanged: (_) => setState(() {}),
                    validator:
                        (v) =>
                            v == null || v.isEmpty ? 'Enter image URL' : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: backgroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submitForm,
                      child: Text(
                        'Save Book',
                        style: TextStyle(fontSize: 16, color: textColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Color(0xFF3A3A3A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.brown),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
