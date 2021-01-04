import 'package:flutter/material.dart';

import 'Models/utility.dart';
import 'Models/recipe.dart';
import 'recipe_page.dart';
import 'Models/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Recipes',
        theme: ThemeData(
            primaryColor: kPrimaryColor,
            backgroundColor: kBackgroundColor
        ),
        home: HomePage(),
        debugShowCheckedModeBanner: false
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> _recipes = List<Recipe>();

  @override
  void initState() {
    setState(() {
      _fetchRecipes();
    });
    super.initState();
  }

  //async function that fetches all recipe data form .json in assets
  void _fetchRecipes() async {
    var jsonHelp = JsonHelper();
    var recipeJsonList = await jsonHelp.getRecipesJson();
    print(recipeJsonList.toString() + 'recipes list');

    for (var recipeJson in recipeJsonList) {
      _recipes.add(Recipe.fromJson(recipeJson));
    }

    setState(() {
      print('Force widget rebuild after fetching Json data');
    });
  }

  //function that creates a route to recipe page
  void _pushRecipePage(Recipe recipe) {
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return RecipePage(recipe);
      }
    ));
  }

  Widget _buildRecipeList() {
    return ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, i) {
          return Card(
            color: kCardColor,
            elevation: 2.5,
            margin: const EdgeInsets.all(kDefaultPadding / 2),
            child: InkWell(
              onTap: () {
                print('Tapped ${_recipes[i].recipeName} card');
                _pushRecipePage(_recipes[i]);
              },
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Text(
                  _recipes[i].recipeName,
                  style: TextStyle(fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kTextColor),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('Home Page widget build function called');
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthy Food Recipes'),
      ),
      body: _buildRecipeList(),
    );
  }
}