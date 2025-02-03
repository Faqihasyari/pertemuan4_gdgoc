import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intensive_study_jam1/barang.dart';

class CustomForm extends StatefulWidget {
  final int id;
  final Function(Map<String, Object?>) onUpdate;
  CustomForm({Key? key, required this.id, required this.onUpdate})
      : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  TextEditingController kode = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController harga = TextEditingController();

  @override
  void initState() {
    super.initState();

    var mhs = Barang().fintById(widget.id);

    kode.text = mhs['kode'].toString();
    nama.text = mhs['barang'].toString();
    harga.text = mhs['Harga'].toString();
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Data Disimpan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kode: ${kode.text}"),
              Text("Nama: ${nama.text}"),
              Text("Harga: ${harga.text}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onUpdate({
                  'barang_id': widget.id,
                  'barang': nama.text,
                });
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: Column(
          children: [
            TextField(
              controller: kode,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp('[0-9]'), allow: true)
              ],
              decoration: InputDecoration(hintText: '', labelText: 'Kode'),
            ),
            TextField(
              controller: nama,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp('[a-z A-Z]'), allow: true)
              ],
              decoration: InputDecoration(hintText: '', labelText: 'Nama'),
            ),
            TextField(
              controller: harga,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp('[0-9]'), allow: true)
              ],
              decoration: InputDecoration(hintText: '', labelText: 'harga'),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showPopup();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Simpan')],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
