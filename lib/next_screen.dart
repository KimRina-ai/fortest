import 'package:flutter/material.dart';

class NextScreen extends StatelessWidget{
  const NextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const Scaffold(
        body: Center(
          child: Text('다음 페이지'),
        )
    );
  }
}