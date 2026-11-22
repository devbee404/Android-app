import 'package:flutter/material.dart';
import '../module/module_screen.dart';
import '../qaida/qaida_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const modules = <({String title, String subtitle, IconData icon, String file})>[
    (title: 'নূরানী কায়দা', subtitle: 'আরবি হরফ ও শুদ্ধ উচ্চারণ', icon: Icons.menu_book, file: 'qaida'),
    (title: 'নামাজ শিক্ষা', subtitle: 'ওযু থেকে পাঁচ ওয়াক্ত নামাজ', icon: Icons.mosque, file: 'namaz'),
    (title: 'দোয়া ও যিকির', subtitle: 'দৈনন্দিন দোয়া ও তাসবিহ', icon: Icons.volunteer_activism, file: 'duas'),
    (title: 'ছোট সূরা মুখস্থ', subtitle: 'আরবি, অর্থ ও তিলাওয়াত', icon: Icons.auto_stories, file: 'surahs'),
    (title: 'নামাজের সময়', subtitle: 'স্থানীয় সময়সূচি ও নোটিফিকেশন', icon: Icons.access_time, file: 'prayer'),
    (title: 'ইসলামিক কুইজ', subtitle: 'শিখুন ও নিজের জ্ঞান যাচাই করুন', icon: Icons.quiz, file: 'quiz'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ইসলামিক শিক্ষা'),
        actions: [
          IconButton(
            tooltip: 'সেটিংস',
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const ModuleScreen(title: 'সেটিংস', assetPath: 'assets/data/quiz/sample_quiz.json'),
            )),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [Color(0xFF176B4D), Color(0xFF2D9270)],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('আসসালামু আলাইকুম', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('সহজভাবে শিখুন, অনুশীলন করুন এবং প্রতিদিন এগিয়ে যান।', style: TextStyle(color: Colors.white)),
                SizedBox(height: 14),
                Text('আপনার শেখার যাত্রা শুরু হোক এখান থেকে।', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('শিক্ষার বিভাগসমূহ', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...modules.map((m) => Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(m.icon, color: Theme.of(context).colorScheme.primary),
              ),
              title: Text(m.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(m.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => m.file == 'qaida'
                    ? const QaidaScreen()
                    : ModuleScreen(
                  title: m.title,
                  assetPath: switch (m.file) {
                    'qaida' => 'assets/data/qaida/lessons.json',
                    'namaz' => 'assets/data/namaz/steps.json',
                    'duas' => 'assets/data/duas/duas.json',
                    'surahs' => 'assets/data/surahs/surahs.json',
                    'quiz' => 'assets/data/quiz/sample_quiz.json',
                    _ => 'assets/data/districts/bangladesh_districts.json',
                  },
                ),
              )),
            ),
          )),
          const SizedBox(height: 12),
          const Text('কনটেন্ট অফলাইনে ব্যবহারযোগ্য। বিজ্ঞাপন বা বিলিং কাজ না করলেও শেখার সুবিধা বন্ধ হবে না.',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
