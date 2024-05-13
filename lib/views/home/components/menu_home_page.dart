
import 'package:flutter/material.dart';

import 'controle_box_widget.dart';



class MenuHomePage extends StatelessWidget {
  final String title;
  final int value;
  final Color titleBodyColor;
  final Color bodyColor;
  final Color barColor;

  final void Function()? increment;
  final void Function()? decrement;
  final void Function(double)? onChangedSlider;

  const MenuHomePage({
    required this.title,
    required this.value,
    required this.titleBodyColor,
    required this.bodyColor,
    required this.barColor,
    required this.increment,
    required this.decrement,
    required this.onChangedSlider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;


    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.03, vertical: size.height * 0.05),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: titleBodyColor,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: size.width * 0.01),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
                ),
              ),
            ),
            // ignore: sized_box_for_whitespace
            Container(
              width: double.infinity,
              color: bodyColor,
              child: Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: 10, horizontal: size.width * 0.25),
                    child: ControleBoxAPP(
                      title: value.toString(),
                      clickPlus: increment,
                      clickMinus: decrement,
                    ),
                  ),
                  //slider
                 Slider(
                        value: value.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: value.toString(),
                        onChanged: onChangedSlider,
                        activeColor: barColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}