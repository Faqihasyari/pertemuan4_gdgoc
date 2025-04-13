import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intensive_study_jam1/form.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          // apiKey: "AIzaSyDaWbS4YT0QlqC8Pi64O-I6Bro0_QC-jN4",
          apiKey: "AIzaSyCeNMHFsI7dF-vhjk0hps68ffzwYxHbzcE", // current_key
          // appId: "1:489919808349:android:ba7755a64fd9fe31a65eb4",
          appId:
              "1:1036357616131:android:be7ebdc91d72e933ec4436", // mobilesdk_app_id
          messagingSenderId: "1036357616131", // project_number
          // messagingSenderId: "489919808349",
          projectId: "barang-f2c85" // project_id
          )
      // projectId: "crud-firebase-e765b")
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Demo Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Daftar Barang',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data = [];

  @override
  void initState() {
    super.initState();

    CollectionReference brg = FirebaseFirestore.instance.collection('barang');

    brg.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          data.add(element.data());
        });
      });
    });
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> row, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content:
              Text("Apakah Anda yakin ingin menghapus data ${row['kode']}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup pop-up tanpa menghapus
              },
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () {
                _deleteData(row, index); // Hapus data jika dikonfirmasi
                Navigator.of(context).pop(); // Tutup pop-up konfirmasi
              },
              child: Text("Ya", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteData(Map<String, dynamic> row, int index) {
    CollectionReference brg = FirebaseFirestore.instance.collection('barang');

    // Cari dokumen berdasarkan field 'kode'
    brg.where('kode', isEqualTo: row['kode']).get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete(); // Hapus dokumen berdasarkan referensi
      }

      setState(() {
        data.removeAt(index); // Hapus dari state agar UI diperbarui
      });

      _showDeleteSuccess(); // Tampilkan notifikasi sukses
    }).catchError((error) {
      print("Gagal menghapus data: $error");
    });
  }

  void _showDeleteSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Informasi"),
          content: Text("Data berhasil dihapus."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            var row = data[index];

            if (index == 0) {
              return Column(
                children: [
                  ElevatedButton(
                      onPressed: () => (Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CustomForm(
                              onUpdate: (updatedData) {
                                setState(() {
                                  data.add(updatedData);
                                });
                              },
                            );
                          }))),
                      child: Text('Tambah Data')),
                  ListTile(
                    title: Text(row['nama']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row['kode'].toString()),
                        Text(row['harga'].toString()),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.blue),
                      onPressed: () {
                        _showDeleteConfirmation(context, row, index);
                      },
                    ),
                  )
                ],
              );
            } else {
              return ListTile(
                title: Text(row['nama']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row['kode'].toString()),
                    Text(row['harga'].toString()),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.blue),
                  onPressed: () {
                    _showDeleteConfirmation(context, row, index);
                  },
                ),
              );
            }
          },
        ),
      ),
    ));
  }
}
