import 'package:flutter/material.dart';

class Trade extends StatefulWidget {

  @override
  State<Trade> createState() => _TradeState();
}

class _TradeState extends State<Trade> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(
      children: <Widget>[
        Container(height: 200, ),
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            child: ListView.builder(
                itemCount : 100,
                itemBuilder : (BuildContext context, int index){
                  return Text("aaa", style: TextStyle(color: Colors.white),);
                }),
          ),
        )
      ],
    ));
  }
}
