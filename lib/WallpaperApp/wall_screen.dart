import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();


}

  class _WallScreenState extends State<WallScreen> {

    StreamSubscription<QuerySnapshot> subscription;
    List<DocumentSnapshot> wallpapersList;
    final CollectionReference collectionReference = Firestore.instance.collection("wallpapers");

    @override
      void initState() {
        super.initState();

        subscription=collectionReference.snapshots().listen((datasnapshot){
            setState(() {
                          wallpapersList=datasnapshot.documents;  //updates walllplist after changes in firestore
                        });
        });      
      
      }
  
  @override
    void dispose() {
      
      // TODO: implement dispose
      subscription?.cancel(); //if subs is not null cancel it
      super.dispose();
    }

  @override
    Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("AnimeWall")
              ),  
        body: wallpapersList !=  null?
        new StaggeredGridView.countBuilder(
          padding: const EdgeInsets.all(8.0),
          crossAxisCount: 4,
          itemCount: wallpapersList.length,
          itemBuilder: (context,i){
            String imgPath= wallpapersList[i].data['url'];
            return new Material(
                elevation: 8.0,
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                child: new InkWell(
                  child: new Hero(
                    tag: imgPath,
                    child: FadeInImage(
                      image: new NetworkImage(imgPath),
                      fit: BoxFit.cover,
                      placeholder: new AssetImage("assets/2.png"),
                      
                    ),
                  ),
                ),
            );
          },       
          staggeredTileBuilder: (i) => new StaggeredTile.count(2, i.isEven ? 2 : 3),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          ):  new Center(
            child:new CircularProgressIndicator(),
          )   
        
        
        
     );
  }
}