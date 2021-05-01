import 'package:flutter/material.dart';

class EditMenu extends StatefulWidget {
  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  String description = "", name = "";
  double price = 0.0;

  @override
  Widget build(BuildContext context) {
    Map Value = ModalRoute.of(context)!.settings.arguments as Map;
    if (description.isEmpty)
      setState(() {
        description = Value['description'];
        price = Value['price'];
        name = Value['name'];
      });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Edit Menu')),
        body: Container(
          margin: EdgeInsets.only(top: 20.0),
          padding: EdgeInsets.only(left: 30.0, top: 15.0, right: 30.0),
          child: Column(
            children: [
              TextField(
                controller: new TextEditingController.fromValue(
                    new TextEditingValue(
                        text: name,
                        selection:
                            new TextSelection.collapsed(offset: name.length))),
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  hoverColor: Colors.tealAccent[100],
                  suffixIcon: Icon(Icons.fastfood),
                ),
                onChanged: (val) {
                  name = val;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: new TextEditingController.fromValue(
                    new TextEditingValue(
                        text: description,
                        selection: new TextSelection.collapsed(
                            offset: description.length))),
                maxLength: 50,
                maxLines:
                    null, // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                decoration: InputDecoration(
                  labelText: 'Description',
                  hoverColor: Colors.tealAccent[100],
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.description),
                  isDense: true,
                  contentPadding: EdgeInsets.all(30),
                ),
                onChanged: (val) {
                  description = val;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: new TextEditingController.fromValue(
                    new TextEditingValue(
                        text: price.toString(),
                        selection: new TextSelection.collapsed(
                            offset: price.toString().length))),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Price',
                    hoverColor: Colors.tealAccent[100],
                    border: OutlineInputBorder(),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        '\u20B9',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
                onChanged: (val) {
                  price = double.parse(val);
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  String docID = Value['docID'];
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
