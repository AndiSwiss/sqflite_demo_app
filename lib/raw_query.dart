import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflitedemoapp/database_helper.dart';

class RawQuery extends StatefulWidget {
  @override
  State createState() => _RawQueryState();
}

class _RawQueryState extends State<RawQuery> {
  final dbHelper = DatabaseHelper.instance;
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Examples for queries:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '''
SELECT * FROM my_table ...
        ... WHERE title='Extraction'
SELECT COUNT(*) FROM my_table
SELECT sql FROM sqlite_master''',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RaisedButton(
                  color: Colors.lightBlue,
                  child: Text(
                    'execute',
//              style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    String input = myController.text;
                    var answer = await dbHelper.executeRawQuery(input);
                    if (answer != null) {
                      print('your answer is:');
                      print(answer);
                    }
                  },
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration:
                      InputDecoration(hintText: 'Type a raw SQL-query...'),
                  controller: myController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
