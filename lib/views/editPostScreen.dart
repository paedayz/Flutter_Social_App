import 'package:flutter/material.dart';
import '../services/database.dart';
import '../helperFunctions/sharedpref_helper.dart';

class EditPost extends StatefulWidget {
  var id;
  var body;

  EditPost({Key key, @required this.id, this.body}) : super(key: key);
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  String _textEditing = "";
  bool _isEdit = false;

  onTextChange(value) {
    print(value);
    _isEdit = true;
    _textEditing = value;
    setState(() {});
  }

  editPost() async {
    var postInfo = {
      'body': _textEditing,
    };

    DatabaseMethods()
        .editPost(postInfo, widget.id)
        .then((value) => Navigator.of(context).pushNamed('/homescreen'));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: widget.body,
                  onChanged: (value) => onTextChange(value),
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      (_isEdit
                          ? ElevatedButton(
                              onPressed: () => editPost(),
                              child: Text('Edit'),
                            )
                          : ElevatedButton(
                              onPressed: null,
                              child: Text('Edit'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.black38,
                                ),
                              ),
                            )),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        height: 400.0,
        color: Colors.white,
      ),
    );
  }
}
