import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_places/helpers/db_helper.dart';
import 'package:my_places/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items]; //just copy of items
  }

  void addPlace(
    String pickedTitle,
    File pickedImage,
  ) {
    final newPlace = Place(
        id: DateTime.now().toString(),
        image: pickedImage,
        title: pickedTitle,
        location: null);
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert("Palaces", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
    });
  }

  Future<void> fetchAndPlaces() async {
    final dataList = await DBHelper.getData("places");
    _items = dataList
        .map((item) => Place(
              id: item["id"],
              title: item["title"],
              image: File(item["image"]),
              location: null,
            ))
        .toList();
    notifyListeners();
  }
}
