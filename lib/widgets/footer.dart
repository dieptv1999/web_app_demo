import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0,bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phoenix',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontFamily: 'DancingScript',
              ),
            ),
            Text(
              'Developer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'COPYRIGHT © 2020 PHOENIX. DESIGNED BY ĐIỆP TRẦN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
    );
  }
}
