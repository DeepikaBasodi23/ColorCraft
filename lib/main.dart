import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const ColorCraftyApp());
}

class ColorCraftyApp extends StatelessWidget {
  const ColorCraftyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ColorCrafty',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const ColorCraftyHome(),
    );
  }
}

class ColorCraftyHome extends StatefulWidget {
  const ColorCraftyHome({super.key});

  @override
  State<ColorCraftyHome> createState() => _ColorCraftyHomeState();
}

class _ColorCraftyHomeState extends State<ColorCraftyHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;

  late Animation<Color?> _backgroundColor1;
  late Animation<Color?> _backgroundColor2;

  Color selectedColor = const Color(0xFF9C27B0);

  final Random random = Random();

  final List<Color> paletteColors = [
    const Color(0xFFE57373),
    const Color(0xFFF06292),
    const Color(0xFFBA68C8),
    const Color(0xFF9575CD),
    const Color(0xFF7986CB),
    const Color(0xFF64B5F6),
    const Color(0xFF4FC3F7),
    const Color(0xFF4DD0E1),
    const Color(0xFF4DB6AC),
    const Color(0xFF81C784),
    const Color(0xFFAED581),
    const Color(0xFFDCE775),
    const Color(0xFFFFD54F),
    const Color(0xFFFFB74D),
    const Color(0xFFFF8A65),
    const Color(0xFFA1887F),
    const Color(0xFF90A4AE),
    const Color(0xFF78909C),
    const Color(0xFF607D8B),
    const Color(0xFF455A64),
  ];

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _backgroundColor1 = ColorTween(
      begin: const Color(0xFFE1F5FE),
      end: const Color(0xFFF3E5F5),
    ).animate(_backgroundController);

    _backgroundColor2 = ColorTween(
      begin: const Color(0xFFFFF3E0),
      end: const Color(0xFFE0F2F1),
    ).animate(_backgroundController);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  String getHexValue(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  void selectColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void generateRandomColor() {
    setState(() {
      selectedColor = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    });
  }

  Color getTextColor(Color color) {
    return color.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _backgroundColor1.value!,
                _backgroundColor2.value!,
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 650),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App title
                        const Text(
                          'ColorCrafty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A148C),
                            letterSpacing: 1.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Explore colors. Create something beautiful.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Selected color preview
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          width: double.infinity,
                          height: 190,
                          decoration: BoxDecoration(
                            color: selectedColor,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: selectedColor.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Selected Color',
                                style: TextStyle(
                                  color: getTextColor(selectedColor),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                getHexValue(selectedColor),
                                style: TextStyle(
                                  color: getTextColor(selectedColor),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Palette heading
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Choose Your Color',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A148C),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Circular color palette
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: paletteColors.map((color) {
                            final bool isSelected =
                                selectedColor.toARGB32() == color.toARGB32();

                            return GestureDetector(
                              onTap: () => selectColor(color),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: isSelected ? 48 : 42,
                                height: isSelected ? 48 : 42,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white70,
                                    width: isSelected ? 4 : 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 22,
                                      )
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 30),

                        // Random color button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: generateRandomColor,
                            icon: const Icon(Icons.shuffle),
                            label: const Text(
                              'Generate Random Color',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A1B9A),
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Tap a color or generate a new one!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}