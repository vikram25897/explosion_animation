import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:explosion_animation/explosion_animation.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
class Home extends StatelessWidget{
  String number;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (str){
                number = str;
              },
              decoration: InputDecoration(
                hintText: "Number Of particles",
              ),
            ),
            MaterialButton(
                color: Colors.red,
                padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: Text("Pick An Image"),
                onPressed: (){
              getImage(context);
            }),
          ],
        ),
      ),
    );
  }
  getImage(BuildContext context)async{
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    Navigator.push(context, MaterialPageRoute(builder: (c)=>MyHomePage(file: img,number:number == null ?100:int.parse(number))));
  }
}
var key = Explode.getKey();
class MyHomePage extends StatefulWidget {
  final File file;
  final int number;
  MyHomePage({Key key, this.title,this.file,this.number}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          child: InkWell(
            onTap: (){
              key.currentState.explode();
            },
            child: Explode(
              key: key,
              size: Size(300, 300),
              fit: BoxFit.cover,
              particleCount: widget.number ?? 100,
              path: widget.file.path,
              type: ExplodeType.Spread,
              isAsset: false,
            ),
          ),
        ),
      ),
    );
  }
}

