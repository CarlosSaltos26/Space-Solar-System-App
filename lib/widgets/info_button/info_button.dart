import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoButton extends StatelessWidget {
  final VoidCallback onTap;

  const InfoButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Image.asset(
        'assets/buttons/boton.png',
        width: 20,
        height: 20,
      ),
    );
  }
}