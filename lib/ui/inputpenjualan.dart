import 'package:flutter/material.dart';
//untuk http package
import 'package:http/http.dart' as http;
import './home.dart';
import 'dart:async';
//untuk date picker
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class InputPenjualan extends StatelessWidget {
  final list;
  final index;
  InputPenjualan({this.list, this.index});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: index == null ? "Transaksi Baru" : "Update Transaksi",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title:
              index == null ? Text("Transaksi Baru") : Text("Update Transaksi"),
        ),
        body: MyCustomForm(list: list, index: index),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  final list;
  final index;
  MyCustomForm({this.list, this.index});
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController namapembeliController = TextEditingController();
  TextEditingController namabarangController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  final format = DateFormat('yyyy-MM-dd');
  Future<http.Response> adddata(index) async {
    if (index = null) {
      final http.Response response = await http
          .post('http://192.168.1.73/apiflutter/penjualan/save', body: {
        'nama_pembeli': namapembeliController.text,
        'nama_barang': namabarangController.text,
        'harga': hargaController.text,
        'keterangan': keteranganController.text,
        'jumlah': jumlahController.text,
        'tanggal': tanggalController.text,
      });
      return response;
    } else {
      final http.Response response = await http
          .post('http://192.168.1.73/apiflutter/penjualan/save_update', body: {
        'id': widget.list['id'],
        'nama_pembeli': namapembeliController.text,
        'nama_barang': namabarangController.text,
        'harga': hargaController.text,
        'keterangan': keteranganController.text,
        'jumlah': jumlahController.text,
        'tanggal': tanggalController.text,
      });
      return response;
    }
  }

  @override
  //untuk load pertama kali form
  void initState() {
    if (widget.index == null) {
      namapembeliController = TextEditingController();
      namabarangController = TextEditingController();
      hargaController = TextEditingController();
      keteranganController = TextEditingController();
      jumlahController = TextEditingController();
      tanggalController = TextEditingController();
    } else {
      namapembeliController =
          TextEditingController(text: widget.list['nama_pembeli']);
      namabarangController =
          TextEditingController(text: widget.list['nama_barang']);
      hargaController = TextEditingController(text: widget.list['harga']);
      keteranganController =
          TextEditingController(text: widget.list['keterangan']);
      jumlahController = TextEditingController(text: widget.list['jumlah']);
      tanggalController = TextEditingController(text: widget.list['tanggal']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Mohon isi Nama Pembeli';
                  }
                  return null;
                },
                //menampilkan controller dalam textfield
                controller: namapembeliController,
                decoration: InputDecoration(
                    labelText: "Nama Pembeli",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0))),
              )),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Mohon isi Nama Barang';
                  }
                  return null;
                },
                //menampilkan controller dalam textfield
                controller: namabarangController,
                decoration: InputDecoration(
                    labelText: "Nama Barang",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0))),
              )),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Harga",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0))),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Mohon isi dengan Angka';
                  }
                  return null;
                },
              )),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: keteranganController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Keterangan",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Mohon isi dengan Email';
                  }
                  return null;
                },
              )),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Jumlah Barang",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0))),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Mohon isi dengan Angka';
                  }
                  return null;
                },
              )),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                //widget DateTimeField terdapat pada package datetime_picker_formfield
                DateTimeField(
                  controller: tanggalController,
                  format: format,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        //setting datepicker
                        context: context,
                        firstDate: DateTime(2020),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2045));
                  },
                  decoration: InputDecoration(
                    labelText: "Tanggal",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                  ),
                  validator: (DateTime dateTime) {
                    if (dateTime == null) {
                      return "Mohon diisi tanggal";
                    }
                    return null;
                  },
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      //tombol penyimpanan
                      child: RaisedButton(
                    color: Colors.deepOrange,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      "Simpan",
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        //jika lolos validator maka data dikirm ke fungsi adddata
                        adddata(widget.index);
                        //keluar form, kembali ke halaman home
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Home()));
                      }
                    },
                  )),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    //untuk Batal
                    child: RaisedButton(
                      color: Colors.deepOrange,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        "Batal",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        //batal kembali ke halaman home
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Home()));
                      },
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
