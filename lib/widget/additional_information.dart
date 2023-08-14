import 'package:flutter/material.dart';

class AdditionalInformationCard extends StatelessWidget {
  final String text;
  final String amount;
  final IconData icon;
  const AdditionalInformationCard(
      {super.key,
      required this.text,
      required this.amount,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: 117.3,
      child: Center(
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(
              height: 6,
            ),
            Text(
              text,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              amount,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
