


import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintPage extends StatefulWidget {
  final List<Map<String, dynamic>>data;
  PrintPage(this.data);
  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg ='';
  final f = NumberFormat("\$###,###.00", "en_US");
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)=> {initPrinter()});
    super.initState();
  }
  Future<void> initPrinter()async{
    bluetoothPrint.startScan(timeout: Duration(seconds: 2));
    if(!mounted) return;
    bluetoothPrint.scanResults.listen((val) {
      if(!mounted) return;
      setState(() {
        _devices = val;
      });
      if(_devices.isEmpty){
        setState(() {
          _devicesMsg = "NO devices found";
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:  true,
        title: Text("Select printer"),
        backgroundColor: Colors.redAccent,
      ),
      body: _devices.isEmpty ?Center(child: Text(_devicesMsg ?? ''),):
          ListView.builder(
            itemCount: _devices.length,
            itemBuilder: (c, i){
              return ListTile(
                leading: Icon(Icons.print),
                title: Text(_devices[i].name),
                subtitle: Text(_devices[i].address),
                onTap: (){
                  _statPrint(_devices[i]);
                },
              );
            },
          ),
    );
  }
  Future<void> _statPrint(BluetoothDevice device)async{
    if(device !=null && device.address !=null){
      await bluetoothPrint.connect(device);
      Map<String,dynamic> config = Map();
      List<LineText> list = [];
      
      
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "Grocery type",
        weight: 2,
        width: 2,
        align: LineText.ALIGN_CENTER,
        linefeed: 1
      ));
      for(var i = 0; i < widget.data.length; i++){
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: widget.data[i]['title'],
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1
        ));
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "${f.format(this.widget.data[i]['price'])} x ${widget.data[i]['qty']}",
          align: LineText.ALIGN_LEFT,
          linefeed: 1
        ));
      }
    }
  }
}
