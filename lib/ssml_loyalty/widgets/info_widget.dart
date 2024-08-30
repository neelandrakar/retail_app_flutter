import 'package:flutter/material.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          'At Starbucks, we\'re more than just a cup of coffee. We\'re a community of individuals who share a passion for inspiring and nurturing the human spirit. Our mission is to empower and connect people everywhere.\n\n'
              'We\'re guided by a set of values that shape everything we do. We strive to create a culture of warmth and belonging, pursue innovation and excellence, and give back to our communities.\n\n'
              'Our story began in 1971, when Jerry Baldwin, Zev Siegl, and Gordon Bowker opened the first Starbucks store in Seattle\'s Pike Place Market. The store quickly became a hub for coffee lovers, and our founders\' passion for quality and customer service set the tone for the company\'s future growth.\n\n'
              'Today, we\'re proud to be a global company with a presence in over 80 countries around the world. We\'re committed to making a positive impact on the world around us, through initiatives like sustainability, education, and community development.',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
