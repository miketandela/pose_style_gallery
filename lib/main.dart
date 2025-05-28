import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(const PoseApp());
}

class PoseApp extends StatelessWidget {
  const PoseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Pose Gallery',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> categories = [
    'Boys',
    'Girls',
    'Men',
    'Women',
    'Couples',
    'Lovers',
    'Gays',
    'Lesbians',
    'Wedding',
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // More apps page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MoreAppsPage()),
      );
    } else if (index == 2) {
      final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.yourapp.id');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Play Store')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Poses'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(child: Text('Poses', style: TextStyle(fontSize: 24))),
            ),
            ...categories.map((category) {
              return ListTile(
                title: Text(category),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryPage(category: category),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
      body: _selectedIndex == 0 ? const HomePage() : const SizedBox.shrink(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'More'),
          BottomNavigationBarItem(icon: Icon(Icons.star_rate), label: 'Rate Us'),
        ],
      ),
    );
  }
}


// Home tab with 4 sample poses from assets
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Only show 4 sample poses on Home page
    List<String> images = List.generate(30, (index) => 'assets/images/pose${index + 1}.jpeg');

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Welcome to the Photo Pose Gallery',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: images.length,
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(images[index], fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}


// Category pages with 12 sample images
class CategoryPage extends StatelessWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<String> images = List.generate(
      12,
      (index) => 'https://picsum.photos/seed/${category.toLowerCase()}$index/400/300',
    );

    return Scaffold(
      appBar: AppBar(title: Text('$category Poses')),
      body: GridView.builder(
        itemCount: images.length,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (context, index) => Image.network(images[index], fit: BoxFit.cover),
      ),
    );
  }
}

// More Apps page with developer info and sample links
class MoreAppsPage extends StatelessWidget {
  const MoreAppsPage({super.key});

  final List<Map<String, String>> apps = const [
    {'name': 'Prayer Time App', 'link': 'https://play.google.com/store/apps/details?id=prayer.app'},
    {'name': 'Quran Study', 'link': 'https://play.google.com/store/apps/details?id=quran.app'},
    {'name': 'Tandela Weather', 'link': 'https://play.google.com/store/apps/details?id=weather.tandela'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More Apps')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.asset('assets/dev.jpg', height: 120),
          const SizedBox(height: 10),
          const Text('Developed by Tandelabintricky', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ...apps.map((app) {
            return ListTile(
              leading: const Icon(Icons.arrow_forward),
              title: Text(app['name']!),
              onTap: () async {
                final url = Uri.parse(app['link']!);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
