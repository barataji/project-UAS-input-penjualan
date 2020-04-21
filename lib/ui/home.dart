import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'inputpenjualan.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List penjualanList;
  int count = 0;
  Future<List> getData() async {
    final response = await http.get('http://192.168.1.73/apiflutter/penjualan');
    //convert kedalam json
    return json.decode(response.body);
  }

  //memamnggil fungsi future pertama kali
  @override
  void initState() {
    Future<List> penjualanListFuture = getData();
    penjualanListFuture.then((penjualanList) {
      setState(() {
        this.penjualanList = penjualanList;
        this.count = penjualanList.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepOrange,
        title: new Text("Penjualan Laptop"),
      ),
      //menampilkan data dalam fungsi createListView
      //sama seperti pada modul 2
      body: createListView(),
      //tombol add
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.deepOrange,
          tooltip: 'Input Penjualan',
          onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new InputPenjualan(
                    list: null,
                    index: null,
                  )))),
    );
  }

//sebuah fungsi untuk menampilkan data dalam list view
  ListView createListView() {
//delete
    Future<http.Response> deletePenjualan(id) async {
      final http.Response response = await http
          .delete('http://192.168.1.73/apiflutter/penjualan/delete/$id');
      return response;
    }

    void confirm(id, namapembeli) {
      AlertDialog alertDialog = new AlertDialog(
        content: new Text("Anda yakin hapus penjualan '$namapembeli'"),
        actions: <Widget>[
          new RaisedButton(
            child: new Text(
              "Ok Hapus!",
              style: new TextStyle(color: Colors.black),
            ),
            color: Colors.red,
            onPressed: () {
              deletePenjualan(id);
              Navigator.of(context, rootNavigator: true).pop();
              initState();
            },
          ),
          new RaisedButton(
            child: new Text("Batal", style: new TextStyle(color: Colors.black)),
            color: Colors.green,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      );
      showDialog(context: context, child: alertDialog);
    }

    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
              title: Text(
                penjualanList[index]['nama_pembeli'],
                style: textStyle,
              ),
              subtitle: Row(
                children: <Widget>[
                  Text(penjualanList[index]['tanggal'].toString().toString()),
                  Text(
                    " | Rp. " + penjualanList[index]['harga'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              //icon delete
              trailing: GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () => confirm(penjualanList[index]['id'],
                      penjualanList[index]['nama_pembeli'])),
              //klik list untuk tampilkan form update

              onTap: () =>
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => new InputPenjualan(
                            list: penjualanList[index],
                            index: index,
                          )))),
        );
      },
    );
  }
}
