import 'package:flutter/material.dart';
import '../utility/globals.dart' as globals;
import '../businessLogic/user_add_screen_bl.dart';

class CurrentUserAddView extends StatefulWidget {
  CurrentUserAddView(this.currentUserAddScreenBL);

  CurrentUserAddScreenBL currentUserAddScreenBL;

  @override
  _CurrentUserAddViewState createState() => _CurrentUserAddViewState();
}

class _CurrentUserAddViewState extends State<CurrentUserAddView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          title: Text(
            'Your Adds',
            style: TextStyle(fontSize: globals.kBigHeaderSize),
          ),
          actions: [
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                newAdd();
              },
              child: Text("New Add"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: buildAddList());
  }

  Widget buildAddList() {
    var currentAddList = widget.currentUserAddScreenBL.currentUserAdds;
    return ListView.builder(
        itemCount: currentAddList.length,
        itemBuilder: (context, i) {
          var currentAdd = currentAddList[i];
          var currentAddAuthorName =
              widget.currentUserAddScreenBL.userData["userName"];
          return Card(
            color: Colors.white30,
            elevation: 2.5,
            margin: const EdgeInsets.all(globals.kDefaultPadding / 2),
            child: InkWell(
              onTap: () {
                editAdd(i);
              },
              child: Padding(
                  padding: const EdgeInsets.all(globals.kDefaultPadding),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          currentAdd["addTitle"],
                          style: TextStyle(
                              fontSize: globals.kBigHeaderSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        currentAdd["addBody"],
                        maxLines: 100,
                        style: TextStyle(
                            fontSize: globals.kHeaderSize,
                            fontWeight: FontWeight.normal),
                      ),
                      Text("Tel: ${currentAdd["addTel"]}"),
                      Text("Link: ${currentAdd["addLink"]}"),
                      Text("Add posted by: $currentAddAuthorName")
                    ],
                  )),
            ),
          );
        });
  }

  Future editAdd(int addIndex) async {
    var editableAdd = widget.currentUserAddScreenBL.currentUserAdds[addIndex];
    var titleEditingController =
        TextEditingController(text: editableAdd["addTitle"]);
    var bodyEditingController =
        TextEditingController(text: editableAdd["addBody"]);
    var linkEditingController =
        TextEditingController(text: editableAdd["addLink"]);
    var telEditingController =
        TextEditingController(text: editableAdd["addTel"]);

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
                            controller: titleEditingController,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Add Title',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                            style: TextStyle(height: 1.2, fontSize: 18),
                            autocorrect: true,
                          )),
                      Container(
                          padding: EdgeInsets.all(globals.kDefaultPadding / 8),
                          child: TextField(
                            controller: bodyEditingController,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Add Body',
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            style: TextStyle(height: 1.15, fontSize: 18),
                            autocorrect: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: 7,
                            minLines: 7,
                          )),
                      Container(
                          padding: EdgeInsets.all(globals.kDefaultPadding / 8),
                          child: TextField(
                            controller: linkEditingController,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Add link',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                            style: TextStyle(height: 1.2, fontSize: 18),
                            autocorrect: true,
                          )),
                      Container(
                          padding: EdgeInsets.all(globals.kDefaultPadding / 8),
                          child: TextField(
                            controller: telEditingController,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Add Tel',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                            style: TextStyle(height: 1.2, fontSize: 18),
                            autocorrect: true,
                          )),
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
                            height: 25,
                            child: RaisedButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                          ButtonTheme(
                            height: 25,
                            child: RaisedButton(
                                child: Text('Save'),
                                color: globals.kThemeColor,
                                onPressed: () async {
                                  var editedAdd = Map<String, dynamic>();
                                  editedAdd["ID"] = editableAdd["ID"];
                                  editedAdd["addTitle"] =
                                      titleEditingController.text;
                                  editedAdd["addBody"] =
                                      bodyEditingController.text;
                                  editedAdd["addLink"] =
                                      linkEditingController.text;
                                  editedAdd["addTel"] =
                                      telEditingController.text;
                                  editedAdd["creatorID"] =
                                      editableAdd["creatorID"];

                                  print(editedAdd.toString());


                                  await widget.currentUserAddScreenBL
                                      .updateAdd(editedAdd);
                                  setState(() {
                                    print("update state");
                                  });
                                  Navigator.of(context).pop();
                                }),
                          )
                        ],
                      )),
                      Container(
                        child: ButtonTheme(
                          height: 25,
                          child: RaisedButton(
                              child: Text('Delete Add'),
                              color: Colors.red,
                              onPressed: () async {
                                await widget.currentUserAddScreenBL
                                    .deleteAdd(editableAdd["ID"]);
                                setState(() {
                                  print("update state");
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

  Future newAdd() async {
    //add structure
    //ID
    //addTitle
    //addBody
    //addLink
    //addTel
    //creatorID
    var titleEditingController =
    TextEditingController();
    var bodyEditingController =
    TextEditingController();
    var linkEditingController =
    TextEditingController();
    var telEditingController =
    TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
                padding: const EdgeInsets.all(globals.kDefaultPadding / 2),
                height: 300,
                child: Column(
                  children: [
                    Container(
                      height: 235,
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(globals.kDefaultPadding / 8),
                              child: TextField(
                                controller: titleEditingController,
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Add Title',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ))),
                                style: TextStyle(height: 1.2, fontSize: 18),
                                autocorrect: true,
                              )),
                          Container(
                              padding: EdgeInsets.all(globals.kDefaultPadding / 8),
                              child: TextField(
                                controller: bodyEditingController,
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Add Body',
                                    border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.black))),
                                style: TextStyle(height: 1.15, fontSize: 18),
                                autocorrect: true,
                                keyboardType: TextInputType.multiline,
                                maxLines: 7,
                                minLines: 7,
                              )),
                          Container(
                              padding: EdgeInsets.all(globals.kDefaultPadding / 8),
                              child: TextField(
                                controller: linkEditingController,
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Add link',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ))),
                                style: TextStyle(height: 1.2, fontSize: 18),
                                autocorrect: true,
                              )),
                          Container(
                              padding: EdgeInsets.all(globals.kDefaultPadding / 8),
                              child: TextField(
                                controller: telEditingController,
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Add Tel',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ))),
                                style: TextStyle(height: 1.2, fontSize: 18),
                                autocorrect: true,
                              )),
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
                                    height: 25,
                                    child: RaisedButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ),
                                  ButtonTheme(
                                    height: 25,
                                    child: RaisedButton(
                                        child: Text('Save'),
                                        color: globals.kThemeColor,
                                        onPressed: () async {
                                          var newAdd = Map<String, dynamic>();
                                          newAdd["ID"] = null;
                                          newAdd["addTitle"] =
                                              titleEditingController.text;
                                          newAdd["addBody"] =
                                              bodyEditingController.text;
                                          newAdd["addLink"] =
                                              linkEditingController.text;
                                          newAdd["addTel"] =
                                              telEditingController.text;
                                          newAdd["creatorID"] = widget.currentUserAddScreenBL.userData["ID"];

                                          print(newAdd.toString());

                                          await widget.currentUserAddScreenBL
                                              .insertNewAdd(newAdd);

                                          setState(() {
                                            print("update state");
                                          });
                                          Navigator.of(context).pop();
                                        }),
                                  )
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}
