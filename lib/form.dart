import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CustomForm extends StatefulWidget {
  final Map<String, dynamic>? data;

  final Function(Map<String, Object?>) onUpdate;
  CustomForm({Key? key, required this.onUpdate, this.data})
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
            onPressed: () async {
              Navigator.of(context).pop();

              // Simpan ke Firestore
              await FirebaseFirestore.instance.collection('barang').add({
                "kode": kode.text,
                "nama": nama.text,
                "harga": int.tryParse(harga.text) ?? 0, // Pastikan harga dalam bentuk angka
              });

              // Perbarui state lokal
              widget.onUpdate({
                "kode": kode.text,
                "nama": nama.text,
                "harga": harga.text,
              });

              // Kosongkan field setelah menyimpan
              kode.clear();
              nama.clear();
              harga.clear();
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
