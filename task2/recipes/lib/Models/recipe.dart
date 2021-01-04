class Recipe {
  int recipeID;
  String recipeName;
  String recipeDesc;
  String recipeIngredients;
  String recipeImage;
  Map<String, dynamic> recipeInstructions;

  Recipe(this.recipeID, this.recipeName, this.recipeDesc, this.recipeImage,
      this.recipeIngredients, this.recipeInstructions);

  Recipe.fromJson(Map<String, dynamic> json) {
    recipeID = json['recipeID'];
    recipeName = json['recipeName'];
    recipeDesc = json['recipeDesc'];
    recipeImage = json['recipeImage'];
    recipeIngredients = json['recipeIngredients'];

    recipeInstructions = json['recipeInstructions'];
  }
}
