import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../utility/globals.dart' as globals;
import '../models/product.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  DatabaseReference databaseReference;
  List<Product> productList = List<Product>();
  StreamSubscription<Event> productSub;
  AnimationController animCont;

  @override
  void dispose() {
    super.dispose();
    productSub.cancel();
  }

  @override
  void initState() {
    super.initState();
    animCont = AnimationController(
      vsync: this,
      duration: new Duration(seconds: 7),
    );
    animCont.repeat();
    databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.keepSynced(true);

    productSub = databaseReference.onValue.listen((Event event) {
      setState(() {
        populateProductList();
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
        print(error.message);
      });
    });

    readData();

    // populating product list
    populateProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(globals.appName),
          actions: [
            FlatButton(
              textColor: Colors.black,
              onPressed: () {
                addProduct();
              },
              child: Text("Add Product"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: productListView());
  }

  void populateProductList() {
    productList.clear();
    databaseReference.once().then((DataSnapshot snapshot) {
      readData();
      if (snapshot.value != null) {
        var productJsonList = castDynamicList(snapshot.value);
        productJsonList.removeWhere((element) => element == null);
        if (productJsonList.isNotEmpty) {
          productList =
              productJsonList.map((e) => Product.fromJson(e)).toList();
          print(productList);
        }
        setState(() {
          print("re-rendering");
        });
      }
    });
  }

  List<dynamic> castDynamicList(x) {
    if (x is List<dynamic>) {
      return List<dynamic>.from(x, growable: true);
    } else if (x is LinkedHashMap) {
      var map = LinkedHashMap.from(x);
      return List<dynamic>.from(map.values, growable: true);
    } else {
      return List<dynamic>();
    }
  }

//child: Text("Uh Oh, no products in our database...")
  Widget productListView() {
    if (productList.isEmpty) {
      return Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: new AnimatedBuilder(
          animation: animCont,
          child: new Container(
            height: 150.0,
            width: 150.0,
            child: Text("Uh Oh, no products in our database..."),
          ),
          builder: (BuildContext context, Widget _widget) {
            return new Transform.rotate(
              angle: animCont.value * 6.3,
              child: _widget,
            );
          },
        ),
      );
    } else {
      return ListView.builder(
          itemCount: productList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.all(8),
              elevation: 8,
              child: InkWell(
                  // todo: edit product on screen press
                  onTap: () {
                    editProduct(productList[index]);
                  },
                  child: Container(
                      // Sets the padding for all elements in the container
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Container(
                          // This makes the with of the element 65 % of the device-width
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        productList[index].name,
                                        style: TextStyle(
                                            fontSize:
                                                globals.kDefaultHeaderSize,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    productList[index].price + ' €',
                                    style: TextStyle(
                                      fontSize: globals.kDefaultHeaderSize,
                                      fontWeight: FontWeight.w600,
                                      color: globals.kAccentBlack,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  productList[index].description,
                                  style: TextStyle(
                                    color: globals.kAccentBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          )))),
            );
          });
    }
  }

  Future editProduct(Product productData) async {
    var nameEC = TextEditingController(text: productData.name);
    var descriptionEC = TextEditingController(text: productData.description);
    var priceEC = TextEditingController(text: productData.price);

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
            padding: const EdgeInsets.all(globals.kDefaultPadding / 2),
            height: 350,
            child: Column(
              children: [
                Container(
                  height: 235,
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(globals.kDefaultPadding / 8),
                          child: TextField(
                            controller: nameEC,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Product Name',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                            style:
                                TextStyle(fontSize: globals.kDefaultHeaderSize),
                            autocorrect: true,
                          )),
                      Container(
                          padding: EdgeInsets.all(globals.kDefaultPadding / 8),
                          child: TextField(
                            controller: descriptionEC,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Product Description',
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            style:
                                TextStyle(fontSize: globals.kDefaultHeaderSize),
                            autocorrect: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: 7,
                            minLines: 7,
                          )),
                      Container(
                          padding: EdgeInsets.all(globals.kDefaultPadding / 8),
                          child: TextField(
                            controller: priceEC,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Product Price',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                            style:
                                TextStyle(fontSize: globals.kDefaultHeaderSize),
                            autocorrect: true,
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ButtonTheme(
                            //height: 25,
                            child: RaisedButton(
                                color: Colors.grey,
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                          ButtonTheme(
                            //height: 25,
                            child: RaisedButton(
                                child: Text('Save'),
                                color: globals.kThemeColor,
                                onPressed: () async {
                                  databaseReference
                                      .child(productData.id)
                                      .update({
                                    'name': nameEC.text,
                                    'description': descriptionEC.text,
                                    'price': priceEC.text
                                  });
                                  setState(() {
                                    print("re-rendering");
                                  });
                                  Navigator.of(context).pop();
                                }),
                          )
                        ],
                      )),
                      Container(
                        child: ButtonTheme(
                          //height: 25,
                          child: RaisedButton(
                              child: Text('Delete'),
                              color: Colors.red,
                              onPressed: () async {
                                databaseReference
                                    .child(productData.id)
                                    .remove();
                                setState(() {
                                  print("re-rendering");
                                });
                                Navigator.of(context).pop();
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
        });
  }

  void readData() {
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  void addProduct() {
    Navigator.pushNamed(context, "/qr_scan").then((value) {
      if (value != null) {
        print(value.toString());
        Map<String, dynamic> productJson = jsonDecode(value.toString());
        databaseReference.child(productJson['id']).set({
          'name': productJson['name'],
          'description': productJson['description'],
          'price': productJson['price'],
          'id': productJson['id']
        });
      }
    });
  }
}
