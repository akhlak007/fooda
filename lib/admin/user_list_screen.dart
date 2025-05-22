import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirestoreService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: StreamBuilder<List<AppUser>>(
        stream: firestore.getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                title: Text(u.displayName),
                subtitle: Text('${u.email}\n${u.phone}\n${u.address}'),
              );
            },
          );
        },
      ),
    );
  }
}
