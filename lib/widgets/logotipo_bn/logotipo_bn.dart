import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:space_solar_app/core/responsive_helper.dart';

class LogotipoBn extends StatelessWidget {
  const LogotipoBn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height: 140.h,
        child: SvgPicture.asset(
          'assets/LogoSpaceBN.svg',
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          //colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)
        ),
      ),
    );
  }
}
