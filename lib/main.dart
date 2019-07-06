import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:path/path.dart';
import 'package:async/async.dart';

String txt = "";
String txt1 = "Upload or take an image to figure out what type of cricket shot it is";
void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Cricket Shot Classifier",
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File img;

  // The fuction which will upload the image as a file
  void upload(File imageFile) async {
    var stream =
    new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    String base =
        "https://types-of-cricket-shots.onrender.com";

    var uri = Uri.parse(base + '/analyze');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      int l = value.length;
      if(value == '{"result":"scoop"}'){
        txt = "Scoop";
      }
      else if(value =='{"result":"coverdrive"}'){
        txt = "Cover Drive";
      }
      else if(value =='{"result":"straightdrive"}'){
        txt = "Straight Drive";
      }
      else if(value == '{"result":"helicoptershot"}'){
        txt = "Helicopter Shot";
      }
      else if(value == '{"result":"pull"}'){
        txt = "Pull Shot";
      }
      else if(value == '{"result":"sweep"}'){
        txt = "Sweep Shot";
      }
      else{
        txt = value;
      }

      setState(() {});
    });
  }


  void lol(int a) async {
    txt1 = "";
    setState(() {

    });
    debugPrint("Lol Activated");
    if (a == 0){
      img = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    else{
      img = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    txt = "Analysing...";
    debugPrint(img.toString());
    upload(img);
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Cricket Shot Classifier"),
      ),
      body: new Container(
        child: Center(
          child: Column(
            children: <Widget>[
              img == null
                  ? new Text(
                txt1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                ),
              )
                  : new Image.file(img,
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.8),
              new Text(
                txt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                ),
              )
            ],
          ),
        ),
      ),
    floatingActionButton: new Stack(
      children: <Widget>[
        Align(
            alignment: Alignment(1.0, 1.0),
            child: new FloatingActionButton(
            onPressed: (){
              lol(0);
            },
            child: new Icon(Icons.camera_alt),

          )
        ),
        Align(
          alignment: Alignment(1.0, 0.8),
          child: new FloatingActionButton(
              onPressed: (){
                lol(1);
              },
              child: new Icon(Icons.file_upload)
          )
        ),

      ],
    ),
    );
  }
}