import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QaidaScreen extends ConsumerStatefulWidget {
  const QaidaScreen({super.key});

  @override
  ConsumerState<QaidaScreen> createState() => _QaidaScreenState();
}

class _QaidaScreenState extends ConsumerState<QaidaScreen> {
  static const _asset = 'assets/data/qaida/lessons.json';
  static const _progressKey = 'qaida_completed_lessons_v1';

  final AudioPlayer _audioPlayer = AudioPlayer();
  late Future<Map<String, dynamic>> _future;
  Set<String> _completed = {};
  int _lessonIndex = 0;
  int _quizIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _quizFinished = false;
  bool _loadingProgress = true;

  @override
  void initState() {
    super.initState();
    _future = _loadContent();
    _loadProgress();
  }

  Future<Map<String, dynamic>> _loadContent() async {
    final raw = await rootBundle.loadString(_asset);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _completed = (prefs.getStringList(_progressKey) ?? []).toSet();
      _loadingProgress = false;
    });
  }

  Future<void> _saveProgress(String id) async {
    final prefs = await SharedPreferences.getInstance();
    _completed.add(id);
    await prefs.setStringList(_progressKey, _completed.toList());
    if (mounted) setState(() {});
  }

  Future<void> _playAudio(String? path) async {
    if (path == null || path.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('এই হরফের অডিও এখনো যুক্ত করা হয়নি।')),
      );
      return;
    }
    try {
      await _audioPlayer.setAsset(path);
      await _audioPlayer.play();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অডিওটি পাওয়া যায়নি।')),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('নূরানী কায়দা'),
        actions: [
          IconButton(
            tooltip: 'শেখার অগ্রগতি',
            icon: const Icon(Icons.insights_outlined),
            onPressed: () => _showProgress(),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('কায়দার পাঠ লোড করা যায়নি।'));
          }
          final lessons = (snapshot.data!['lessons'] as List)
              .cast<Map<String, dynamic>>();
          final lesson = lessons[_lessonIndex];
          final items = (lesson['items'] as List).cast<Map<String, dynamic>>();
          final completedCount = _completed.length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lesson['titleBn'] as String,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Text('${_lessonIndex + 1}/${lessons.length}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: lessons.isEmpty ? 0 : completedCount / lessons.length,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 8),
                    Text(lesson['descriptionBn'] as String),
                    if (lesson['status'] != 'verified')
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          'শিক্ষামূলক কনটেন্ট: প্রকাশের আগে ক্বারি/আলেমের যাচাই প্রয়োজন।',
                          style: TextStyle(fontSize: 11, color: Colors.deepOrange),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 54,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final selected = index == _lessonIndex;
                    final id = lessons[index]['id'] as String;
                    return ChoiceChip(
                      label: Text('${index + 1}. ${lessons[index]['titleBn']}'),
                      selected: selected,
                      avatar: _completed.contains(id)
                          ? const Icon(Icons.check_circle, size: 17)
                          : null,
                      onSelected: (_) => setState(() {
                        _lessonIndex = index;
                        _resetQuiz();
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'এই পাঠের কনটেন্ট তৈরি হচ্ছে। ক্বারি যাচাইয়ের পর এখানে যুক্ত হবে।',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.92,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => _playAudio(item['audio'] as String?),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      item['arabic'] as String? ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: 43,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item['nameBn'] as String? ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  const Icon(Icons.volume_up_outlined, size: 18),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if ((lesson['quiz'] as List).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _openQuiz(lesson),
                      icon: const Icon(Icons.quiz_outlined),
                      label: const Text('এই পাঠের অনুশীলনী'),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _lessonIndex == 0
                            ? null
                            : () => setState(() {
                                  _lessonIndex--;
                                  _resetQuiz();
                                }),
                        child: const Text('আগের পাঠ'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          await _saveProgress(lesson['id'] as String);
                          if (_lessonIndex < lessons.length - 1) {
                            setState(() {
                              _lessonIndex++;
                              _resetQuiz();
                            });
                          } else {
                            _showProgress();
                          }
                        },
                        child: Text(_lessonIndex == lessons.length - 1
                            ? 'পাঠ সম্পন্ন'
                            : 'পাঠ সম্পন্ন ও পরেরটি'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _resetQuiz() {
    _quizIndex = 0;
    _score = 0;
    _selectedAnswer = null;
    _quizFinished = false;
  }

  void _openQuiz(Map<String, dynamic> lesson) {
    _resetQuiz();
    final questions = (lesson['quiz'] as List).cast<Map<String, dynamic>>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            if (_quizFinished) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events_outlined, size: 48),
                      const SizedBox(height: 12),
                      Text('আপনার স্কোর: $_score / ${questions.length}',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('শেষ করুন'),
                      ),
                    ],
                  ),
                ),
              );
            }
            final question = questions[_quizIndex];
            final options = (question['options'] as List).cast<String>();
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20, 24, 20, MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('প্রশ্ন ${_quizIndex + 1}/${questions.length}',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 12),
                    Text(question['questionBn'] as String,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    ...List.generate(options.length, (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: OutlinedButton(
                        onPressed: _selectedAnswer != null
                            ? null
                            : () => modalSetState(() {
                                  _selectedAnswer = i;
                                  if (i == question['correctOptionIndex']) {
                                    _score++;
                                  }
                                }),
                        child: Text(options[i],
                            style: const TextStyle(fontSize: 22)),
                      ),
                    )),
                    if (_selectedAnswer != null)
                      FilledButton(
                        onPressed: () => modalSetState(() {
                          if (_quizIndex < questions.length - 1) {
                            _quizIndex++;
                            _selectedAnswer = null;
                          } else {
                            _quizFinished = true;
                          }
                        }),
                        child: Text(_quizIndex == questions.length - 1
                            ? 'ফলাফল দেখুন'
                            : 'পরের প্রশ্ন'),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showProgress() async {
    if (_loadingProgress) return;
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('আপনার অগ্রগতি'),
        content: Text('সম্পন্ন পাঠ: ${_completed.length}টি'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ঠিক আছে'),
          ),
        ],
      ),
    );
  }
}
