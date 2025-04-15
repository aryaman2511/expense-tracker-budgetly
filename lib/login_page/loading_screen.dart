import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color.fromARGB(255, 10, 215, 191),
                  Color.fromARGB(255, 11, 127, 71)
                ],
                tileMode: TileMode.clamp,
              ).createShader(bounds),
              child: const Text(
                'BudgetLy',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 214, 179, 3),
              strokeWidth: 5,
            ),
          ],
        ),
      ),
    );
  }
}
