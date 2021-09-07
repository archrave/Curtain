import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Curtain'),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('/chats/OLY8NDXS6l75yCRFY31J/messages')
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs = streamSnapshot.data.documents;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (ctx, i) => Container(
                padding: EdgeInsets.all(8),
                child: Text(docs[i]['text']),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('/chats/OLY8NDXS6l75yCRFY31J/messages')
              .add({
            'text': 'Dummy on message by clicking + ',
          });
        },
      ),
    );
  }
}
