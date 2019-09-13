import 'package:flutter/material.dart';

const Color kTextColor = Colors.white24;
const Color kBottomButtonColor = Colors.yellow;
const SliderThemeData kSliderTheme = SliderThemeData(
    activeTrackColor: Colors.white,
    inactiveTrackColor: kTextColor,
    thumbColor: kBottomButtonColor,
    overlayColor: Colors.yellowAccent,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 13.0));

const double kMinHeight = 0.5;
const double kMaxHeight = 10.0;
