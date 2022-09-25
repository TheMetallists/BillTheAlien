import 'dart:convert';
import 'dart:typed_data';

import 'package:billthealien/elementform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pointycastle/export.dart'
    show PBKDF2KeyDerivator, HMac, SHA256Digest;
import 'package:convert/convert.dart';
import 'package:pointycastle/impl.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
          child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: new CircularProgressIndicator(),
            ),
            new Text("Formatting..."),
          ],
        ),
      ));
    },
  );
}

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController passco = TextEditingController();

  Future<void> processLogin(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 400));
    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 32));
    derivator.init(Pbkdf2Parameters(
        Uint8List.fromList(utf8.encode(
            "6Gkz5qRGtroPfkf58XQ+dswKfbqHL73KVxKqjuJCYFisS+KYb08/XLNphrcyjA4i+tJJcFpRwsBl")),
        15000,
        32));
    Uint8List out = Uint8List(32);
    Uint8List inp = Uint8List.fromList(utf8.encode(passco.text));
    derivator.deriveKey(inp, 0, out, 0);

    final derivator2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 32));
    derivator2.init(Pbkdf2Parameters(
        Uint8List.fromList(utf8.encode(
            "UKnOZaTZ9oxScHEF3vHQNy8IOs+xyvwn9C4WPcMQk+iZTi3fOY/qrzR55/Zstea/yv/81Ef5a30")),
        2000,
        32));

    Uint8List out2 = Uint8List(32);
    derivator2.deriveKey(out, 0, out2, 0);
    String keyhash = hex.encode(out2);

    var boxcar = await Hive.openBox("storozh");
    var kexhash = boxcar.get("passwordHash",defaultValue: "admin");
    if(kexhash != keyhash){
      String? res = await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Base abducted!'),
          content: const Text(
              'The thing you\'ve entered is not a valid password. \n'
                  'Or the base is empty. Press \'OK\' if it is, cancel otherwise.\n'
                  'ОК - WILL ERASE EVERYTHING!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (res == null || res != 'OK') {
        Navigator.pop(context);
        return;
      }
      boxcar.put('passwordHash', keyhash);
    }

    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ElementForm(out)));
    //derivator.process(data)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bill, the Alien"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image(image: AssetImage('assets/alien.png')),
            Text(
                'Database for all and everyone. And nobody will leave unfilled.'),
            Flexible(
              child: TextField(
                controller: passco,
                obscureText: true,
                obscuringCharacter: '*',
                onChanged: (val) => {
                  //
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
              child: ElevatedButton(
                  onPressed: () {
                    showLoadingDialog(context);
                    processLogin(context);
                  },
                  child: Text('Crawl in')),
            )
          ],
        ),
      ),
    );
  }
//
}
