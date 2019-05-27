import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_sdk/bloc/app/app_bloc.dart';
import 'package:flutter_chat_sdk/resource/app_resources.dart';
import 'package:flutter_chat_sdk/ui/conversation/chat.dart';
import 'package:flutter_chat_sdk/util/alog.dart';
import 'package:flutter_chat_sdk/widget/avatar_widget.dart';

class People extends StatefulWidget {
  const People({Key key}) : super(key: key);

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  String currentUserId;

  _PeopleState();

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    currentUserId = appBloc.userInfo.uid ?? "";
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.colorThemeAccent),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(context, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    Alog.debug("DocumentSnapshot " + document.data.toString());
//    Alog.debug("currentID : " + currentUserId?? "null");
//    Alog.showToast(currentUserId ?? "null");
    if (document['id'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              AvatarWidget(
                urlAvatar: document['photoUrl'],
                displayName: document['nickname'] ?? document['email'],
                size: 50,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          document['nickname'] ?? document['email'] ?? '',
                          style: TextStyle(color: colorTextTitle),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          '${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: colorTextInfo),
                          maxLines: 1,
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (context) => Chat(
                      peerId: document.documentID,
                      peerAvatar: document['photoUrl'] ?? '',
                      chatWith: document['nickname'] ?? document['email'] ?? '',
                    )));
//            Alog.showToast("Chat with - " + document['nickname']);
          },
//          color: Colors.grey,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
//          shape:
//              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
      );
    }
  }
}
