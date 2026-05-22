import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
    
          colors: [Color(0xFF1a3b5f), Color(0xFF0c1933), Color(0xFF071b2b), Color(0xFF010a11)],
    
          stops: [0.0, 0.39, 0.56, 0.85],
        ),
      )
      
    );
  }
}