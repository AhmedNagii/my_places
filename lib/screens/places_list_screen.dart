import 'package:flutter/material.dart';
import 'package:my_places/providers/great_places.dart';
import 'package:provider/provider.dart';
import '../screens/add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("your places"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: Center(
        // child argument it could be a part that i don't want to update
        child: FutureBuilder(
          future:
              Provider.of<GreatPlaces>(context, listen: false).fetchAndPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlaces>(
                  child:
                      Center(child: Text("Got no Places yet, start add some!")),
                  builder: (ctx, greatPlaces, ch) =>
                      greatPlaces.items.length <= 0
                          ? ch
                          : ListView.builder(
                              itemCount: greatPlaces.items.length,
                              itemBuilder: (ctx, index) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(
                                    greatPlaces.items[index].image,
                                  ),
                                ),
                                title: Text(greatPlaces.items[index].title),
                                onTap: () {
                                  //go to detail page
                                },
                              ),
                            ),
                ),
        ),
      ),
    );
  }
}
