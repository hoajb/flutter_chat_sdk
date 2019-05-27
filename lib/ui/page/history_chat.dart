import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_sdk/bloc/app/app_bloc.dart';
import 'package:flutter_chat_sdk/resource/app_resources.dart';
import 'package:flutter_chat_sdk/ui/conversation/chat.dart';
import 'package:flutter_chat_sdk/util/alog.dart';
import 'package:flutter_chat_sdk/widget/avatar_widget.dart';

class HistoryChat extends StatefulWidget {
  @override
  _HistoryChatState createState() => _HistoryChatState();
}

class _HistoryChatState extends State<HistoryChat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName;
  String currentUserId;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    _userName = "";
    final FirebaseUser user = await _auth.currentUser();

    setState(() {
      _userName = user.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    currentUserId = appBloc.userInfo.uid ?? "";
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('history')
            .document(currentUserId)
            .collection('group')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.colorThemeAccent),
              ),
            );
          } else {
//            return Text(snapshot.data.documents[0]['info'] ?? "null");
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
    Alog.debug("DocumentSnapshotHistory " + document.data.toString());

    return document == null
        ? Container()
        : Container(
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  AvatarWidget(
                    urlAvatar: document['peerAvatar'],
                    displayName: document['peerDisplayName'] ?? '-',
                    size: 50,
                  ),
                  Flexible(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              document['peerDisplayName'] ?? '-',
                              style: TextStyle(color: colorTextTitle),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                          ),
                          Container(
                            child: Text(
                              document['lastMessage'] ?? '- -',
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
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                        builder: (context) => Chat(
                              peerId: document['peerId'],
                              peerAvatar: document['peerAvatar'] ?? '',
                              chatWith: document['peerDisplayName'] ?? '',
                            )));
              },
//              color: (document['group'] as String).startsWith(currentUserId)
//                  ? Colors.green
//                  : Colors.grey,
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            ),
            margin: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
          );
  }
}
