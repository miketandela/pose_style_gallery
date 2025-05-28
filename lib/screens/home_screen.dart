import 'package:flutter/material.dart';
import 'pose_list_screen.dart'; // import this

class HomeScreen extends StatelessWidget {
  final List<String> categories = [
    'Boys',
    'Girls',
    'Couples',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Poses'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PoseListScreen(category: categories[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
