import 'package:HDTech/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserPopup extends StatelessWidget {
  final User user;
  final Function(User) onSave;

  const UpdateUserPopup({super.key, required this.user, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: user.name);
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    final TextEditingController phoneController =
        TextEditingController(text: user.phone);

    return AlertDialog(
      backgroundColor: Colors.white, // Set the dialog background to white
      title: const Text('Update User Info'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name')),
          TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email')),
          TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final updatedUser = User(
              userId: user.userId,
              name: nameController.text,
              email: emailController.text,
              phone: phoneController.text,
            );

            bool success = await UserService()
                .updateUserDetails(updatedUser.userId, updatedUser.toJson());

            if (success) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('name', updatedUser.name);
              prefs.setString('email', updatedUser.email);
              prefs.setString('phone', updatedUser.phone);

              onSave(updatedUser);
              // ignore: use_build_context_synchronously
              Navigator.pop(context, updatedUser);
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to update user info')));
            }
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
