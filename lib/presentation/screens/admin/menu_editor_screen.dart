import 'package:flutter/material.dart';

/// Screen for creating or editing a menu
class MenuEditorScreen extends StatelessWidget {
  final String? menuId;
  
  const MenuEditorScreen({Key? key, this.menuId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEditing = menuId != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Menu' : 'Create Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Editing Menu ID: $menuId' : 'Create a New Menu',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text('This screen is under development'),
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Menu Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save Menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}