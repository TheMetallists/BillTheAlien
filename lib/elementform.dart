import 'dart:typed_data';

import 'package:billthealien/addingPopup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'elementform.g.dart';

class ElementForm extends StatefulWidget {
  late Uint8List _key;

  ElementForm(Uint8List dbkey) {
    _key = dbkey;
  }

  @override
  State<StatefulWidget> createState() => _ElementFormState(_key);
}

class NoteEntry extends StatelessWidget {
  late Toiletpaper _tp;
  late Box<Toiletpaper> _box;
  late int _index;

  NoteEntry(Box<Toiletpaper> box, int index, Toiletpaper tp) {
    _tp = tp;
    _box = box;
    _index = index;
  }

  @override
  Widget build(BuildContext context) {
    String value = '';
    switch (_tp.billValue) {
      case BillValue.r10:
        value = '10';
        break;
      case BillValue.r50:
        value = '50';
        break;
      case BillValue.r100:
        value = '100';
        break;
      case BillValue.r200:
        value = '200';
        break;
      case BillValue.r500:
        value = '500';
        break;
      case BillValue.r1000:
        value = '1000';
        break;
      case BillValue.r2000:
        value = '2000';
        break;
      case BillValue.r5000:
        value = '5000';
        break;
      default:
        value = '';
    }

    String posses = '';
    switch (_tp.state) {
      case BillState.posessment:
        posses = 'IN POSSESSION';
        break;
      case BillState.possesmentMoved:
        posses = 'MOVED TO BANK';
        break;
      case BillState.paidWith:
        posses = 'PAID USING';
        break;
      default:
    }

    return Container(
      height: 55,
      color: Colors.grey[400],
      padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _tp.num_serial + ' ' + (_tp.num_number.toString()),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Text(' R. $value'),
                    ],
                  ),
                  Spacer(),
                  Text(_tp.date_inserted)
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(posses + ' >>'),
                    onPressed: () {
                      int sta = _tp.state.index;
                      sta++;
                      if (sta > (BillState.values.length - 1)) {
                        sta = 0;
                      }

                      _tp.state = BillState.values[sta];
                      _box.put(_index, _tp);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

@HiveType(typeId: 2)
enum BillValue {
  @HiveField(0)
  r10,
  @HiveField(1)
  r50,
  @HiveField(2)
  r100,
  @HiveField(3)
  r200,
  @HiveField(4)
  r500,
  @HiveField(5)
  r1000,
  @HiveField(6)
  r2000,
  @HiveField(7)
  r5000
}

@HiveType(typeId: 3)
enum BillState {
  @HiveField(0)
  posessment,
  @HiveField(1)
  possesmentMoved,
  @HiveField(2)
  paidWith
}

@HiveType(typeId: 1)
class Toiletpaper extends HiveObject {
  Toiletpaper(
      {required this.uuid,
      required this.num_serial,
      required this.num_number,
      required this.billValue,
      required this.date_inserted,
      required this.state});

  @HiveField(0)
  String uuid;

  @HiveField(1)
  String num_serial;

  @HiveField(2)
  int num_number;

  @HiveField(3)
  BillValue billValue;

  @HiveField(4)
  String date_inserted;

  @HiveField(5)
  BillState state;

  @override
  String toString() {
    return '$num_serial $num_number, USD: $billValue';
  }
}

class _ElementFormState extends State<ElementForm> {
  late Uint8List _key;
  bool _loading = true;
  late Box<Toiletpaper> stor;

  _ElementFormState(Uint8List dbkey) {
    _key = dbkey;
    openStorageMedia();
  }

  void openStorageMedia() async {
    Box<Toiletpaper> _stor = await Hive.openBox('entries', encryptionCipher: HiveAesCipher(_key));
    setState(() {
      _loading = false;
      stor = _stor;
    });
  }

  void showAddingPopup(BuildContext context, Box<Toiletpaper> box) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddingPopup(box);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("BILLTHEALIEN LIST"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //
          },
          child: const Icon(Icons.add),
        ),
        drawer: null,
        body: Text('Loading data...'),
      );
    }

    return ValueListenableBuilder(
        valueListenable: stor.listenable(),
        builder: (context, Box<Toiletpaper> box, widget) {
          List<Widget> entries = <Widget>[];
          int index = 0;
          box.values.forEach((element) {
            entries.add(NoteEntry(box, index++, element));
          });
          entries = entries.reversed.toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("BILLTHEALIEN LIST"),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showAddingPopup(context, box);
                /*box.add(Toiletpaper(
                    uuid: 'asd',
                    num_serial: 'RC',
                    num_number: 123456,
                    billValue: BillValue.r500,
                    date_inserted: '11.22.3333 44:55:66',
                    state: BillState.posessment));*/
              },
              child: const Icon(Icons.add),
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(title: new Text("Export possesed"), onTap: () {}),
                  ListTile(title: new Text("Export all to XML"), onTap: () {}),
                ],
              ),
            ),
            body: ListView(
              children: entries,
            ),
          );
        });
  }
}
