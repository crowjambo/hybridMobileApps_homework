import 'package:flutter/material.dart';
import 'package:healthy_food_recipes/Models/recipe.dart';
import 'Models/constants.dart';
import 'Models/utility.dart';
import 'Models/comment.dart';

class CommentPage extends StatefulWidget {
  CommentPage(this.recipeData);

  final Recipe recipeData;

  @override
  _CommentPageState createState() => _CommentPageState(recipeData);
}

class _CommentPageState extends State<CommentPage> {
  _CommentPageState(this.recipeData);

  var _commentList = List<RecipeComment>();
  Recipe recipeData;

  @override
  void initState() {
    setState(() {
      _fetchComments(recipeData.recipeID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeData.recipeName + ' Comments',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: Icon(Icons.add_comment),
              onPressed: () {
                //adding new comment
                print('Tapped add comment button');
                int newCommentID;
                if (_commentList.isEmpty) {
                  newCommentID = 1;
                } else {
                  newCommentID = _commentList.last.commentID + 1;
                }
                RecipeComment newComment = RecipeComment(
                    recipeData.recipeID, newCommentID, null, null);
                _commentList.add(newComment);
                _editComment(context, newComment)
                    .then((comment) => handleEditedComments(comment));
              })
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: Column(children: _commentCardList(recipeData.recipeID)),
      ),
    );
  }

  List<Widget> _commentCardList(int recipeID) {
    var _commentCards = List<Widget>();

    for (var comment in _commentList) {
      _commentCards.add(SizedBox(
          width: double.infinity,
          child: Card(
            color: kCardColor,
            margin: const EdgeInsets.all(kDefaultPadding / 4),
            elevation: 2.5,
            child: InkWell(
                onTap: () {
                  print('Tapped ${comment.commentID.toString()} comment card');
                  _editComment(context, comment)
                      .then((comment) => handleEditedComments(comment));
                },
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(children: [
                    Text(
                      comment.commentTitle,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                          decoration: TextDecoration.underline),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: kDefaultPadding / 2),
                      child: Text(
                        comment.commentBody,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: kTextColor),
                      ),
                    ),
                  ]),
                )),
          )));
    }

    return _commentCards;
  }

  Future<RecipeComment> _editComment(
      BuildContext context, RecipeComment comment) {
    var titleEditingController = TextEditingController();
    var bodyEditingController = TextEditingController();

    if (comment != null) {
      titleEditingController.text = comment.commentTitle;
      bodyEditingController.text = comment.commentBody;
    }

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            height: 390,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(kDefaultPadding / 8),
                    child: TextField(
                      controller: titleEditingController,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Comment Name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.black,
                          ))),
                      style: TextStyle(height: 1.5, fontSize: 20),
                      autocorrect: true,
                    )),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 4,
                        vertical: kDefaultPadding),
                    child: TextField(
                      controller: bodyEditingController,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Comment Body',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                      style: TextStyle(height: 1.5, fontSize: 20),
                      autocorrect: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      minLines: 1,
                    )),
                Container(
                    padding: EdgeInsets.all(kDefaultPadding / 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            padding: EdgeInsets.only(right: 5),
                            child: RaisedButton(
                                child: Text('Delete'),
                                color: Colors.red,
                                onPressed: () {
                                  comment.state = CommentState.deleteComment;
                                  Navigator.of(context).pop(comment);
                                })),
                        RaisedButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        RaisedButton(
                            child: Text('Save'),
                            color: kPrimaryColor,
                            onPressed: () {
                              comment.commentTitle =
                                  titleEditingController.text;
                              comment.commentBody = bodyEditingController.text;
                              comment.state = CommentState.editedComment;
                              Navigator.of(context).pop(comment);
                            }),
                      ],
                    ))
              ],
            ),
          ));
        });
  }

  handleEditedComments(RecipeComment comment) {
    //when comment state didn't change i.e. user pressed 'cancel' we skip
    if (comment == null) {
      return;
    }

    switch (comment.state) {
      //deleting comment
      case CommentState.deleteComment:
        {
          _commentList
              .removeWhere((element) => element.commentID == comment.commentID);
        }
        break;

      //handling new or edited comments
      case CommentState.editedComment:
        {
          _commentList
              .where((element) => element.commentID == comment.commentID)
              .forEach((element) {
            element.commentTitle = comment.commentTitle;
            element.commentBody = comment.commentBody;
          });
        }
        break;

      default:
        {
          return;
        }
        break;
    }

    //todo: after handling do serialization
    serializeComments();

    //calling set state to fetch new serialized comments and rebuild view
    setState(() {
      _fetchComments(recipeData.recipeID);
    });
  }

  serializeComments() async {
    var jsonHelp = JsonHelper();
    var commentJsonList = await jsonHelp.getJsonArray();
    var editedCommentList = List<Map<String, dynamic>>();
    print(commentJsonList.toString());

    for (var comment in _commentList) {
      editedCommentList.add(comment.toJson());
    }

    commentJsonList[commentJsonList.indexWhere(
            (element) => element['recipeID'] == recipeData.recipeID)]
        ['comments'] = editedCommentList;

    var newJsonString = jsonHelp.returnJsonString(commentJsonList);
    jsonHelp.writeJsonStringToFile(newJsonString);

  }

  //async function that fetches all recipe data form .json in assets
  void _fetchComments(int recipeID) async {
    var jsonHelp = JsonHelper();
    await jsonHelp.createJsonFile();

    var commentJsonList = await jsonHelp.getJsonArray();

    var commentsJson = commentJsonList[commentJsonList
        .indexWhere((element) => element['recipeID'] == recipeID)];

    //deleting all comments form comment list to rebuild with edited comments
    _commentList.clear();

    for (var commentJson in commentsJson['comments']) {
      _commentList
          .add(RecipeComment.fromJson(commentJson, commentsJson['recipeID']));
    }

    setState(() {
      print('Force widget rebuild after fetching Json data');
    });
  }
}
