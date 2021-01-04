enum CommentState{
  editedComment,
  deleteComment,
  noState
}

class RecipeComment {
  int commentID;
  int recipeID;
  String commentTitle;
  String commentBody;

  CommentState state = CommentState.noState;

  void changeState(CommentState newState){state=newState;}

  RecipeComment(this.recipeID, this.commentID, this.commentTitle, this.commentBody);

  RecipeComment.fromJson(Map<String, dynamic> json, int recipeId) {
    commentID = json['commentID'];
    recipeID = recipeId;
    commentTitle = json['commentTitle'];
    commentBody = json['commentBody'];
  }

  Map<String, dynamic> toJson() => {
    'commentID' : commentID,
    'commentTitle' : commentTitle,
    'commentBody' : commentBody
  };
}
