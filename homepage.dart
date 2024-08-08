import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}
File? image;
String text="";
String txt="";
bool textrec=false;
FlutterTts fluttertts=FlutterTts();


class _homepageState extends State<homepage> {
  @override
  Future pickImage() async {
  final imagefile = await ImagePicker().pickImage(source: ImageSource.gallery);
  setState((){
  if (imagefile != null) {
    image = File(imagefile.path);
  }
  });
  getRecognisedText(image);
  }


  Future pickImage_cam() async {
    final imagefile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
    if (imagefile != null) {
      image = File(imagefile.path);
    }
    });
    getRecognisedText(image);
   }
  
  Future getRecognisedText (File? image) async{
    textrec=true;
    final img = InputImage.fromFile(image!);
    final TextDetector=GoogleMlKit.vision.textRecognizer();
    final RecognizedText= await TextDetector.processImage(img);
    await TextDetector.close();
    text="";
    for(TextBlock block in RecognizedText.blocks){
      for(TextLine line in block.lines){
        text=text +line.text+"\n";
      }
    }
    print(text);
    setState(() {
      txt=text;
    });
    textrec=false;
    tts(txt);                
  }
  Future tts(String text) async {
    await fluttertts.setLanguage("en-US");
    await fluttertts.setPitch(1);
    await fluttertts.speak(text);
  }

  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text to Speech"),),
      body: SingleChildScrollView(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 50,),
            Center(
              child: Container(
                child: image != null
                ? Image.file(
                    image!,
                    fit: BoxFit.fill,
                  )
                : Image.network("https://thenounproject.com/api/private/icons/1435844/edit/?backgroundShape=SQUARE&backgroundShapeColor=%23000000&backgroundShapeOpacity=0&exportSize=752&flipX=false&flipY=false&foregroundColor=%23000000&foregroundOpacity=1&imageFormat=png&rotation=0&token=gAAAAABj9ShNEUP9TOI8nhdCAkSeKQHbkUy6hkly_pKPJk_GROcVQmSt_A400quCU0ZeiPBihXbn7TjkQhFZhay_fR0A8IJ45A%3D%3D"),
                height: 300,
                width: 300,
                color: Colors.black,
              ),
            ),
            TextButton(onPressed: (){
              showModalBottomSheet(context: context, builder:(context){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.extended(
                            onPressed: (() {
                              pickImage();
                            }),
                            label: Text("Gallery"),
                            icon: Icon(Icons.photo_album),
                            heroTag: null,
                          ),
                          FloatingActionButton.extended(
                            onPressed: (() {
                              pickImage_cam();
                            }),
                            label: Text("Camera"),
                            icon: Icon(Icons.camera),
                            heroTag: null,
                          )
                        ],
                  )
                  ),
                );
              } 
              );
            }, child: Text("pick-image")),
            if(textrec)CircularProgressIndicator(),
            Text(txt),
          ],
        )
         ,),
    );
  }
}