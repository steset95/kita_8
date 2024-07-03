import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'my_delete_button.dart';


class MyListTileFeedKita extends StatefulWidget {
  final String title;
  final String content;
  final String subTitle;
  final String postId;
  final String feed;

  const MyListTileFeedKita({
    super.key,
    required this.title,
    required this.content,
    required this.subTitle,
    required this.postId,
    required this.feed,


  });

  @override
  State<MyListTileFeedKita> createState() => _MyListTileFeedKitaState();
}

class _MyListTileFeedKitaState extends State<MyListTileFeedKita> {

  final CollectionReference users = FirebaseFirestore.instance.collection("Users");
  final CollectionReference posts = FirebaseFirestore.instance.collection("Feed");

  User? user = FirebaseAuth.instance.currentUser;

  void deletePost(String feed) {
    // Bestätigungsdialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eintrag löschen?"),
        actions: [
          //Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Abbrechen"),
          ),
          //Löschen bestätigen
          TextButton(
            onPressed: () async{
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(user!.email)
                  .collection(feed)
                  .doc(widget.postId)
                  .delete();
              Navigator.pop(context);
            },
            child: const Text("Bestätigen"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(
          left: 10, right: 10, bottom: 10
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black)
        ),
        child:
            ListTile(
              title: Column(
                children: [
                  Text(
                      style: TextStyle(fontSize: 18,),
                      widget.title,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: mediaQuery.size.width * 0.80,
                        child: Text(
                          style: TextStyle(fontSize: 12,
                          ),
                            widget.content,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.subTitle,
                  style: TextStyle(
                      fontSize: 8,
                  ),
                  ),
                  IconButton(
                    onPressed: ()  {
                      deletePost(widget.feed);
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 15.0,
                    ),
                  ),
                  ],
                ),
                ),
              ),
    );
  }
}
