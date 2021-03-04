import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_places/helpers/db_helper.dart';
import 'package:my_places/helpers/location_helper.dart';
import 'package:my_places/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items]; //just copy of items
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String pickedTitle,
    File pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);
    final newPlace = Place(
        id: DateTime.now().toString(),
        image: pickedImage,
        title: pickedTitle,
        location: updatedLocation);
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert("Palaces", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
      "loc_lat": newPlace.location.latitude,
      "loc_lng": newPlace.location.latitude,
      "address": newPlace.location.address,
    });
  }

  Future<void> fetchAndPlaces() async {
    final dataList = await DBHelper.getData("places");
    _items = dataList
        .map((item) => Place(
              id: item["id"],
              title: item["title"],
              image: File(item["image"]),
              location: PlaceLocation(
                  latitude: item["lac_lat"],
                  longitude: item["loc_lng"],
                  address: item["address"]),
            ))
        .toList();
    notifyListeners();
  }
}
