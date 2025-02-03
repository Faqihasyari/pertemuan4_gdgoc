import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intensive_study_jam1/form.dart';
import 'package:intensive_study_jam1/barang.dart';

void main() {
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, Object?>> data = Barang().Data();

  void updateData(Map<String, Object?> updatedItem) {
    setState(() {
      int index = data.indexWhere(
          (item) => item['barang_id'] == updatedItem['barang_id']);
      if (index != -1) {
        data[index] = Map<String, Object>.from(updatedItem);
      }
    });
  }

  @override
  void initstate() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang'),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 15),
              child: Table(
                children: [
                  TableRow(
                      decoration: BoxDecoration(color: Colors.blueAccent),
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                          child: Text(
                            'Aksi',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                          child: Text(
                            'Nama',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                  for (final {
                        'barang_id': brg_id as int,
                        'barang': brg,
                      } in data)
                    TableRow(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    CupertinoColors.extraLightBackgroundGray)),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 3),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      DialogRoute(
                                          context: context,
                                          builder: (context) {
                                            return CustomForm(
                                              id: brg_id,
                                              onUpdate: updateData,
                                            );
                                          }));
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 12,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 3),
                            child: Text(
                              brg.toString(),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ])
                ],
              ),
            ),
          ))
        ],
      ),
    ));
  }
}
