import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ControleBoxAPP extends StatelessWidget {
  final String title;
  final void Function()? clickPlus;
  final void Function()? clickMinus;

   ControleBoxAPP({super.key , required this.title, this.clickPlus, this.clickMinus});

  @override
  Widget build(BuildContext context) {
  var size = MediaQuery.of(context).size;
    return  Container(
      width: size.width * 0.8,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green[300],
                  ),
                  child: IconButton(
                      onPressed: clickPlus,
                      icon: const Icon(Icons.plus_one),
                      iconSize: 30,
                  ),
                ),
                Text(
                  title,
                  style:  TextStyle(
                    fontSize: 30,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,

                  ),
                ),
                 Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red[300],
                    ),
                    child: IconButton(
                        onPressed: clickMinus,
                        icon: const Icon(Icons.exposure_minus_1),
                        iconSize: 30,
                    ),
                  ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
