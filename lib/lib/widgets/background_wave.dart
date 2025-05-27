import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundWave extends StatelessWidget {
  const BackgroundWave({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.3, // tinggi SVG area (atur sesuai kebutuhan)
      width: size.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: SvgPicture.asset(
              'assets/svg/Vector.svg',
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: SvgPicture.asset(
              'assets/svg/Vector (1).svg',
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: SvgPicture.asset(
              'assets/svg/Vector (2).svg',
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
