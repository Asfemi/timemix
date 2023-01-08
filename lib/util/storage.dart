import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../model/eventInfo.dart';

final CollectionReference mainCollection = FirebaseFirestore.instance.collection('event');
//we are creating event collection to hold the events information 
//for which we would hold the group information and schedule events from

final DocumentReference documentReference = mainCollection.doc('info');
//the info string should be passed into documentReference 

class Storage {
  Future<void> storeEventData(EventInfo eventInfo) async {
  DocumentReference documentReferencer = documentReference.collection('events').doc(eventInfo.id);

  Map<String, dynamic> data = eventInfo.toJson();

  if (kDebugMode) {
    print('DATA:\n$data');
  }

  await documentReferencer.set(data).whenComplete(() {
    if (kDebugMode) {
      print("Event added to the database, id: {${eventInfo.id}}");
      //todo: display something to the user about this update
    }
  }).catchError((e) => print(e));
  //todo: display something to the user about this error
}


  Future<void> updateEventData(EventInfo eventInfo) async {
  DocumentReference documentReferencer = documentReference.collection('events').doc(eventInfo.id);

  Map<String, dynamic> data = eventInfo.toJson();

  if (kDebugMode) {
    print('DATA:\n$data');
  }

  await documentReferencer.update(data).whenComplete(() {
    //todo: display something to the user about this update
    if (kDebugMode) {
      print("Event updated in the database, id: {${eventInfo.id}}");
    }
  }).catchError((e) => print(e));
  //todo: display something to the user about this error
}


  Future<void> deleteEvent({required String id}) async {
  DocumentReference documentReferencer = documentReference.collection('events').doc(id);

  await documentReferencer.delete().catchError((e) => print(e));
  //todo: display something to the user about this error

//todo: once done display something to the user about this delete action
  if (kDebugMode) {
    print('Event deleted, id: $id');
  }
}


  Stream<QuerySnapshot> retrieveEvents() {
  Stream<QuerySnapshot> myClasses = documentReference.collection('events').orderBy('start').snapshots();

  return myClasses;
 }
}
