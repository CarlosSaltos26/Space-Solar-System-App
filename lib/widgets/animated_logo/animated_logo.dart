import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.network('https://lottie.host/3a7753f9-e790-4054-826c-6a252419a256/5gSRrhwWni.json'),
    );
  }
}