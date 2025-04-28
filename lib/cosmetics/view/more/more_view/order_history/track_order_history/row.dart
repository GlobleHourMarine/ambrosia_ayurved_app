import 'package:flutter/material.dart';

class Sadhna extends StatefulWidget {
  const Sadhna({super.key});

  @override
  State<Sadhna> createState() => _SadhnaState();
}

class _SadhnaState extends State<Sadhna> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'sadhna is react develop9er.',
            style: TextStyle(color: Colors.amber, fontSize: 30),
          ),
          Text('sadhna'),
          Text('sadhna'),
        ],
      ),
    );
  }
}
