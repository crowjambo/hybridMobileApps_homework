import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        primaryColor: Colors.red
      ),
      home: MainButtonScreen()
    );

  }
}

class MainButtonScreen extends StatefulWidget {
  @override
  _MainButtonScreenState createState() => _MainButtonScreenState();
}

class _MainButtonScreenState extends State<MainButtonScreen> {
  bool box1ToggleColor = false;
  bool box2ToggleColor = false;
  bool box3ToggleColor = false;
  bool box4ToggleColor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('task1 app')
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(32),
        child:
          Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(child: Text("Press"), onPressed: (){setState(() {
                  box1ToggleColor = !box1ToggleColor;
                });}),
                Container(
                  width: 125,
                  height: 50,
                  child: Center(child: Text("")),
                  color: box1ToggleColor ? Colors.lightGreen : Colors.red,
                ),
              ],
            ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(child: Text("Press"), onPressed: (){setState(() {
                    box2ToggleColor = !box2ToggleColor;
                  });}),
                  Container(
                    width: 125,
                    height: 50,
                    child: Center(child: Text("")),
                    color: box2ToggleColor ? Colors.black : Colors.white,
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(child: Text("Press"), onPressed: (){setState(() {
                    box3ToggleColor = !box3ToggleColor;
                  });}),
                  Container(
                    width: 125,
                    height: 50,
                    child: Center(child: Text("")),
                    color: box3ToggleColor ? Colors.greenAccent : Colors.orange,
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(child: Text("Press"), onPressed: (){setState(() {
                    box4ToggleColor = !box4ToggleColor;
                  });}),
                  Container(
                    width: 125,
                    height: 50,
                    child: Center(child: Text("")),
                    color: box4ToggleColor ? Colors.indigo : Colors.lime,
                  ),
                ],
              ),
          ],),
      )
    );
  }
}