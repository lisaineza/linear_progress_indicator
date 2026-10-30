import 'package:flutter/material.dart';

void main() => runApp(const CourseApp());

class CourseApp extends StatelessWidget {
  const CourseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CourseProgressPage(),
    );
  }
}

class CourseProgressPage extends StatefulWidget {
  const CourseProgressPage({super.key});

  @override
  State<CourseProgressPage> createState() => _CourseProgressPageState();
}

class _CourseProgressPageState extends State<CourseProgressPage> {
  static const int totalModules = 5;

  bool _loading = false; // true -> value: null (indeterminate)
  double _progress = 0.6; // attribute 1: value (0.0 to 1.0)
  double _height = 4; // attribute 2: minHeight (default is 4)
  int _colorIndex = 0; // attribute 3: color (0 = theme default)

  final List<Color?> _colors = [null, Colors.green, Colors.deepOrange];
  final List<String> _colorNames = ['Default', 'Green', 'Orange'];

  @override
  Widget build(BuildContext context) {
    final modulesDone = (_progress * totalModules).round();
    final percent = (_progress * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('My Courses')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---- The real-world use case: a course progress card ----
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Flutter Fundamentals',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(_loading
                      ? 'Loading your progress...'
                      : 'Module $modulesDone of $totalModules complete • $percent%'),
                  const SizedBox(height: 12),

                  // ---- THE ASSIGNED WIDGET ----
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _loading ? null : _progress, // attribute 1
                      minHeight: _height, // attribute 2
                      color: _colors[_colorIndex], // attribute 3
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ---- Live controls (for the class demo only) ----
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. value',
                      style: Theme.of(context).textTheme.titleMedium),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Indeterminate (value: null)'),
                    value: _loading,
                    onChanged: (v) => setState(() => _loading = v),
                  ),
                  Slider(
                    value: _progress,
                    divisions: totalModules,
                    label: '$percent%',
                    // Disabled while the bar is indeterminate
                    onChanged: _loading
                        ? null
                        : (v) => setState(() => _progress = v),
                  ),
                  const Divider(),
                  Text('2. minHeight (${_height.toStringAsFixed(0)})',
                      style: Theme.of(context).textTheme.titleMedium),
                  Slider(
                    value: _height,
                    min: 4,
                    max: 24,
                    divisions: 20,
                    label: _height.toStringAsFixed(0),
                    onChanged: (v) => setState(() => _height = v),
                  ),
                  const Divider(),
                  Text('3. color',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<int>(
                    segments: [
                      for (int i = 0; i < _colors.length; i++)
                        ButtonSegment(value: i, label: Text(_colorNames[i])),
                    ],
                    selected: {_colorIndex},
                    onSelectionChanged: (s) =>
                        setState(() => _colorIndex = s.first),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}