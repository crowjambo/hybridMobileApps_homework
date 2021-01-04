import 'package:flutter/material.dart';

import '../utility/globals.dart'
    as globals;
import '../businessLogic/home_screen_bl.dart';
import '../screens/user_add_screen.dart';
import '../businessLogic/user_add_screen_bl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.userData);

  final Map<String, dynamic> userData;

  @override
  _HomeScreenState createState() => _HomeScreenState(userData);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(Map<String, dynamic> userData) {
    this.homeScreenBL = HomeScreenBL(userData);
  }

  HomeScreenBL homeScreenBL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          title: Text(
            'All Adds',
            style: TextStyle(fontSize: globals.kBigHeaderSize),
          ),
        ),
        body: HomeScreenBody(homeScreenBL),
        drawer: MenuDrawer(homeScreenBL));
  }
}

//body stuff
class HomeScreenBody extends StatefulWidget {
  HomeScreenBody(this.homeScreenBL);

  HomeScreenBL homeScreenBL;

  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.homeScreenBL.loadAllAdds(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> addList) {
        if (addList.hasData) {
          return buildAddList();
        } else if (addList.hasError) {
          print("error at add list future");
          return Center(child: Text("No Adds Yet..."));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildAddList() {
    var currentAddList = widget.homeScreenBL.shownAdds;
    return ListView.builder(
        itemCount: currentAddList.length,
        itemBuilder: (context, i) {
          var currentAdd = currentAddList[i];
          int currentAddAuthorID = currentAdd["creatorID"];
          var currentAddAuthorName =
              widget.homeScreenBL.users[currentAddAuthorID]["userName"];
          return Card(
            color: Colors.white30,
            elevation: 2.5,
            margin: const EdgeInsets.all(globals.kDefaultPadding / 2),
            child: InkWell(
              onTap: () {},
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
}

// drawer stuff
class MenuDrawer extends StatefulWidget {
  MenuDrawer(this.homeScreenBL);

  HomeScreenBL homeScreenBL;

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              "Menu Drawer",
              style: TextStyle(fontSize: globals.kBigHeaderSize * 1.5),
            ),
            decoration: BoxDecoration(
              color: globals.kAccentColor,
            ),
          ),
          ListTile(
            title: Text("Your adds"),
            leading: Icon(Icons.ac_unit),
            onTap: () {
              showCurrentUserAdds();
            },
          ),
          ListTile(
            title: Text("Log out"),
            leading: Icon(Icons.close),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/login");
            },
          ),
        ],
      ),
    );
  }

  void showCurrentUserAdds() {
    var currentUserAdds = widget.homeScreenBL.loadCurrentUserAdds();
    var userData = widget.homeScreenBL.userData;
    var currentUserAddScreenBL =
        CurrentUserAddScreenBL(userData, currentUserAdds);
    
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => CurrentUserAddView(currentUserAddScreenBL))).then((value) {
          setState(() {
            print("Setting state after editing adds.");
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen(userData)));
    });
    
  }
}
