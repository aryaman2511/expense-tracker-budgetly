import 'package:flutter/material.dart';

class HomeScreenStyle extends StatelessWidget {
  final Widget child;

  const HomeScreenStyle({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0A4D14),
            Color(0xFF1E7A32),
            Color(0xFF0C3A0E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
