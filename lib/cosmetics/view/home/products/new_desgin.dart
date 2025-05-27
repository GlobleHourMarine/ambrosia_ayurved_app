import 'package:flutter/material.dart';

class NewDesgin extends StatelessWidget {
  const NewDesgin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.blueAccent,
            ),
            Container(
              height: double.infinity,
              width: 30,
              color: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}


/*

import 'package:flutter/material.dart';

class NewDesgin extends StatelessWidget {
  const NewDesgin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 32,
          itemBuilder: (context, index) {
            return Container(
              width: 30,
              color: index.isEven ? Colors.blueAccent : Colors.yellow,
            );
          },
        ),
      ),
    );
  }
}



*/


/*

import 'package:flutter/material.dart';

class NewDesgin extends StatelessWidget {
  const NewDesgin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(32, (index) {
            return Container(
              height: double.infinity,
              width: 30,
              color: index.isEven ? Colors.blueAccent : Colors.yellow,
            );
          }),
        ),
      ),
    );
  }
}



*/