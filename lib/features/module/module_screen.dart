import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key, required this.title, required this.assetPath});
  final String title;
  final String assetPath;

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  late Future<dynamic> _content;

  @override
  void initState() {
    super.initState();
    _content = _load();
  }

  Future<dynamic> _load() async {
    final raw = await rootBundle.loadString(widget.assetPath);
    return jsonDecode(raw);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<dynamic>(
        future: _content,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('কনটেন্ট লোড করা যায়নি: ${snapshot.error}'));
          }
          final data = snapshot.data;
          final entries = data is Map ? (data['items'] as List? ?? const []) : const [];
          if (entries.isEmpty) {
            return const Center(child: Text('এই অংশের কনটেন্ট প্রস্তুত করা হচ্ছে।'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = entries[index] as Map<String, dynamic>;
              final title = item['titleBn'] ?? item['nameBn'] ?? item['id'] ?? 'শিক্ষার বিষয়';
              final status = item['status'] ?? 'sample';
              return Card(
                child: ExpansionTile(
                  title: Text('$title'),
                  subtitle: Text(status == 'needs_scholar_review'
                      ? 'আলেমের যাচাই প্রয়োজন'
                      : status == 'todo_verify_license'
                          ? 'লাইসেন্স যাচাই বাকি'
                          : 'নমুনা কনটেন্ট'),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    if (item['arabic'] != null)
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text('${item['arabic']}', style: const TextStyle(fontSize: 27)),
                      ),
                    if (item['instructionBn'] != null) Text('${item['instructionBn']}'),
                    if (item['pronunciationBn'] != null) Text('উচ্চারণ: ${item['pronunciationBn']}'),
                    if (item['meaningBn'] != null) Text('অর্থ: ${item['meaningBn']}'),
                    if (item['source'] != null) Text('সূত্র: ${item['source']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    if (item['audio'] != null) Text('অডিও: ${item['audio']}'),
                    if (item['status'] != null) Text('অবস্থা: ${item['status']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
