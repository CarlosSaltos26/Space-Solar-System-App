import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:space_solar_app/core/responsive_helper.dart';

class Logotipo extends StatelessWidget {
  const Logotipo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            // Ajusta según necesites
            width: 580.w,
            child: SvgPicture.asset(
              'assets/LogotipoSpace.svg',
              //colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)
            ),
          ),
        ),
      ),
    );
  }
}
