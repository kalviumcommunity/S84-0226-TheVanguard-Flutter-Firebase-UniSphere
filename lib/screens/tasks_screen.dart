import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Tasks'),
      ),
      body: Column(
        children: [
          // Single Document Read (FutureBuilder)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('config')
                  .doc('app_info')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return const Text('Error loading app info');
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text('App Info: Not found');
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final version = data?['version'] ?? 'Unknown Version';
                
                return Card(
                  child: ListTile(
                    title: const Text('App Configuration'),
                    subtitle: Text('Version: $version'),
                    leading: const Icon(Icons.info),
                  ),
                );
              },
            ),
          ),
          
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Tasks List (Real-time)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Collection Read (StreamBuilder)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load tasks.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No tasks available. \nAdd some in the Firestore Console."));
                }

                final tasks = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final data = task.data() as Map<String, dynamic>;
                    
                    final title = data['title'] ?? 'No Title';
                    final description = data['description'] ?? 'No Description';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.task_alt),
                        title: Text(title),
                        subtitle: Text(description),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
