


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/screen/printpage.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List <Map<String, dynamic>> data =[
    {'title': 'dairy milk', 'price': 20, 'qty':  2},
    {'title': 'cadbary dairy milk', 'price': 10, 'qty': 5},
    {'title': 'chocolate dairy milk', 'price': 30, 'qty': 6},
    {'title': 'Mango juice', 'price': 60, 'qty': 6},
  ];
  final f = NumberFormat("\$###,###.00", "en_US");
  @override
  Widget build(BuildContext context) {
    int _total = 0;
    _total = data.map((e) => e['price'] * e['qty']).
    reduce((value, element) => value + element);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        title: Text("Flutter - Thermal Printer"),
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (c, i){
              return ListTile(
                title: Text(data[i]['title'].toString(),
                style: TextStyle(
                  fontSize: 16
                ),),
                subtitle: Text('${f.format(data[i]['price'])} x ${data[i]['qty']}'),
                trailing: Text(f.format(data[i]['price'] * data[i]['qty'])),
              );
            },
          )),
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text("Total: ${f.format(_total)}",style: TextStyle(
                  fontWeight: FontWeight.w700
                ),),
                SizedBox(width: 80,),
                Expanded(child: TextButton.icon(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.green
                  ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>PrintPage(data)));
                    },
                    icon: Icon(Icons.print), label: Text("Print")))
              ],
            ),
          )
        ],
      ),
    );
  }
}
