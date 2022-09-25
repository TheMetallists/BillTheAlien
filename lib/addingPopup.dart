import 'package:billthealien/elementform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddingPopup extends StatefulWidget {
  late Box<Toiletpaper> _box;

  AddingPopup(Box<Toiletpaper> box) {
    _box = box;
  }

  @override
  State<StatefulWidget> createState() => _AddingPopupState(_box);
}

class _AddingPopupState extends State<AddingPopup> {
  late Box<Toiletpaper> _box;

  _AddingPopupState(Box<Toiletpaper> box) {
    _box = box;
  }

  TextEditingController frmSerial = TextEditingController();
  TextEditingController frmNumber = TextEditingController();
  int frmValue = 2;
  int frmPosession = 0;

  @override
  Widget build(BuildContext context) {
    List<int> nvals = <int>[10, 50, 100, 200, 500, 1000, 2000, 5000];
    List<int> ivals = <int>[0, 1, 2, 3, 4, 5, 6, 7];
    List<String> pvals = ['Posession', 'Moved to bank', 'Paid with'];
    var uuid = Uuid();

    return AlertDialog(
      content: Stack(
        children: <Widget>[
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Serial #'),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        child: TextFormField(
                          controller: frmSerial,
                          maxLength: 2,
                          decoration: InputDecoration(
                            counterText: '',
                            border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.cyan)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      ),
                      Flexible(
                          child: TextFormField(
                        controller: frmNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        maxLength: 9,
                        decoration: InputDecoration(
                          counterText: '',
                          border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.cyan)),
                        ),
                      )),
                    ],
                  ),
                ),
                DropdownButton<int>(
                  value: frmValue,
                  items: ivals.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(nvals[value].toString() + ' \$'),
                    );
                  }).toList(),
                  onChanged: (nv) {
                    setState(() {
                      frmValue = nv!;
                    });
                  },
                ),
                DropdownButton<int>(
                  value: frmPosession,
                  items: <int>[0, 1, 2].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(pvals[value]),
                    );
                  }).toList(),
                  onChanged: (npval) {
                    setState(() {
                      frmPosession = npval!;
                    });
                  },
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          child: Text("Add"),
                          onPressed: () async {
                            DateTime now = DateTime.now();
                            String formattedDate = DateFormat('d.M.y HH:mm:ss').format(now);

                            await _box.add(Toiletpaper(
                                uuid: uuid.v1(),
                                num_serial: frmSerial.text,
                                num_number: int.parse(frmNumber.text),
                                billValue: BillValue.values[frmValue],
                                date_inserted: formattedDate,
                                state: BillState.values[frmPosession]));
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Forget'))
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
