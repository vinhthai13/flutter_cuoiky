import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ColorfulProgressBar(),
    );
  }
}

class ColorfulProgressBar extends StatefulWidget {
  const ColorfulProgressBar({super.key});

  @override
  _ColorfulProgressBarState createState() => _ColorfulProgressBarState();
}

class _ColorfulProgressBarState extends State<ColorfulProgressBar> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // Repeat animation indefinitely

    _progress = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to get the color based on progress
  Color getProgressColor(double progress) {
    if (progress < 0.33) {
      return Colors.red; // Low progress (0% to 33%)
    } else if (progress < 0.66) {
      return Colors.yellow; // Medium progress (34% to 66%)
    } else {
      return Colors.green; // High progress (67% to 100%)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Colorful Progress Bar'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Gradient Progress Bar with dynamic color and percentage
            AnimatedBuilder(
              animation: _progress,
              builder: (context, child) {
                double progress = _progress.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background progress bar
                    Container(
                      width: 300,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                    ),
                    // Animated progress bar with color change
                    Container(
                      width: 300 * progress,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: getProgressColor(progress), // Dynamic color
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            // Percentage Text below the progress bar
            AnimatedBuilder(
              animation: _progress,
              builder: (context, child) {
                return Text(
                  '${(_progress.value * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
