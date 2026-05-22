import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:space_solar_app/core/responsive_helper.dart';

class Sun extends StatelessWidget {
  const Sun({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.w,
      height: 200.h,
      child: Lottie.network('https://lottie.host/fdbc4744-dedb-41f0-a709-e61da79acf3b/PE9VP32Jsr.json'),
    );
  }
}