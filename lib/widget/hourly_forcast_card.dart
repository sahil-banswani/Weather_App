import 'package:flutter/material.dart';

class HourlyForcastCard extends StatelessWidget {
  final String value;
  final String time;
  final String image;
  const HourlyForcastCard(
      {super.key,
      required this.value,
      required this.time,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 100,
        height: MediaQuery.of(context).size.height * 0.15,
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Text(
                time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 32,
                  width: 32,
                  child: Image.asset(
                    'assets/weather/$image.png',
                  )),
              const SizedBox(
                height: 8,
              ),
              Text("$value ^C")
            ],
          ),
        ),
      ),
    );
  }
}
