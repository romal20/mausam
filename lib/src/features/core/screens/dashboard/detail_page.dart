import 'package:flutter/material.dart';
import 'package:mausam/src/constants/core_constants.dart';

class DetailPage extends StatefulWidget {

  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forecast'),
      ),
    );
  }
}
