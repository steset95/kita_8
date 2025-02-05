
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/database/firestore_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../database/firestore_images_profile.dart';
import '../helper/helper_functions.dart';
import '../old/my_image_upload_button_profile.dart';


class ImageViewerProfile extends StatefulWidget {
  final String childcode;

  const ImageViewerProfile({
    super.key,
    required this.childcode,

  });

  @override
  State<ImageViewerProfile> createState() => _ImageViewerProfileState();
}

/*

Zum Anzeigen ImageViewerProfile(),

 */

final currentUser = FirebaseAuth.instance.currentUser;

class _ImageViewerProfileState extends State<ImageViewerProfile> {
  @override
  Widget build(BuildContext context) {
    final StorageProfile storage = StorageProfile();
    final childcode = widget.childcode;
    return Row(
          children: [
            FutureBuilder(
                future: storage.downloadURL(
                    '/profile/$childcode/Profilbild'),
                builder: (BuildContext context,
                    AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () async {
                          final results = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.media,
                            //allowedExtensions: ['png', 'jpg'],
                          );
                          if (results == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Kein Bild ausgewählt")
                              ),
                            );
                            return null;
                          }
                          final path = results.files.single.path!;
                          final fileName = results.files.single.name;

                          storage
                              .uploadFileProfile(path, fileName, widget.childcode)
                              .then((value) => print('Erledigt'));
                          return
                            displayMessageToUser("Bild wird hochgeladen...", context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(45),
                              // Image radius
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    );
                  }
                  return
                    GestureDetector(
                      onTap: () async {
                        final results = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.media,
                          //allowedExtensions: ['png', 'jpg'],
                        );
                        if (results == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Kein Bild ausgewählt")
                            ),
                          );
                          return null;
                        }
                        final path = results.files.single.path!;
                        final fileName = results.files.single.name;

                        storage
                            .uploadFileProfile(path, fileName, widget.childcode)
                            .then((value) => print('Erledigt'));
                        return
                          displayMessageToUser("Bild wird hochgeladen...", context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(45),
                            // Image radius
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                      size: 14,
                                    ),
                                    const SizedBox(height: 4),
                                    Text("Profilbild hinzufügen",
                                        style: TextStyle(fontSize: 9,
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                }
            ),
          ],
        );

  }
}

