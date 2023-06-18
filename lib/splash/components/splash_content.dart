import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'constants.dart';

class SplashContent extends StatelessWidget {
  const SplashContent(
      {Key? key,
      required this.text,
      required this.image,
      required this.headtitle})
      : super(key: key);
  final String text, image;
  final String headtitle;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // print("gtgtrg " + headtitle);
    return Column(children: <Widget>[
      const Spacer(),
      Text(
        headtitle,
        style: TextStyle(
          fontSize: getProportionateScreenWidth(32),
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(text),
      const Spacer(flex: 1),
      Image.asset(
        image,
        height: getProportionateScreenHeight(265 * 2),
        width: getProportionateScreenWidth(235 * 2),
        // scale: 0.02,
      ),
    ]);
  }
}
