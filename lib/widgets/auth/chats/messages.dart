import 'package:chatapp_oldv/widgets/auth/chats/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // Now the current user doesn't return a future instead it works synchronously
    /* FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : */
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'timestamp',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        final chatDocs = chatSnapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            return MessageBubble(
              //  chatDocs[index]['text'], (old convention)

              // Now we have to user the extra data() method to extroct data from a particular document
              chatDocs[index].data()['text'],
              chatDocs[index].data()['username'],
              chatDocs[index].data()['userId'] == user.uid,
              chatDocs[index].data()['userImage'],
              key: ValueKey(
                //chatDocs[index].documentID,
                chatDocs[index].id,
              ),
            );
            //  Text(chatDocs[index]['text']);
          },
        );
      },
    );
  }
}
