import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OffBase64',
      theme: ThemeData(
        // colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(
            title:const Center(
              child: Text('OffBase64'),
            ),
          ),
          body: const MainPage()),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final encodetxtcontroller= TextEditingController();
    final decodetxtcontroller=  TextEditingController();


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataBox(
        htext: "Encode Text here",
          key: Key('Encode'),
           txtcontrolr: encodetxtcontroller,
          desttxtcontrolr: decodetxtcontroller,
      ),
        DataBox(
          htext: "Decode Text here",
          key: Key('Decode'),
            txtcontrolr: decodetxtcontroller,
          desttxtcontrolr: encodetxtcontroller,
      )
      ],
    );
  }
}

class DataBox extends StatefulWidget {

  const DataBox({super.key, required this.htext, required this.txtcontrolr,required this.desttxtcontrolr});
  final String htext;
  final TextEditingController txtcontrolr;
  final TextEditingController desttxtcontrolr;

  @override
  State<DataBox> createState() => _DataBoxState();


}

class _DataBoxState extends State<DataBox> {

  String textdata="";
  bool isEncode=true;

  @override
  void initState(){
    textdata=widget.htext;
    final textcontroller=widget.txtcontrolr;
    if(widget.key==Key("Decode")){
      isEncode=false;
    }
    super.initState();
  }
  @override
  void dispose()
  {
    // textcontroller.dispose();
    super.dispose();
  }

  void updatetext() {
    try {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      if (isEncode) {
        widget.desttxtcontrolr.text =stringToBase64.encode( widget.txtcontrolr.text );
      }
      else{

        widget.desttxtcontrolr.text = stringToBase64.decode( widget.txtcontrolr.text );;
      }
    } on Exception catch (e) {
      widget.desttxtcontrolr.text = "Not valid text";

    }
    catch (error) {
      widget.desttxtcontrolr.text = "Not valid text";
  }

  }


  @override
  Widget build(BuildContext context) {
    //TODO stack copy and paste buttons on the right bottom.
    return Container(
      padding: const EdgeInsets.all(30),

      alignment: Alignment.center,
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        elevation: 20.0,
        shadowColor: Colors.grey,
        child: Focus(
          onFocusChange: (hasFocus) {
            if(hasFocus) {
              // print('focus at + $textdata');
                  // widget.desttxtcontrolr.removeListener(updatetext);
              widget.txtcontrolr.addListener(updatetext);
            }
            else{
              widget.txtcontrolr.removeListener(updatetext);
            }
          },
          child: SizedBox(
            child: Stack(
              children: [
                TextField(
                          controller: widget.txtcontrolr,
                          keyboardType: TextInputType.multiline,
                          maxLines: 6,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.fromLTRB(8, 75, 8, 8),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                            hintText: textdata,
                            filled: true,
                            // fillColor: Colors.green,
                          ),
                        ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,

                    child: Opacity(
                      opacity: 0.7,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: widget.txtcontrolr.text));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Text copied"),
                            duration: const Duration(milliseconds: 500),
                          ));
                          // copied successfully
                        },
                        child: const Text('Copy'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}