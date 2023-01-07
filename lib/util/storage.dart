import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/eventInfo.dart';

final CollectionReference mainCollection = FirebaseFirestore.instance.collection('event');
//todo: create a proper name(with naming rules and all)
//todo: for the collection
//todo: search on how to create multi events based on my app specifications
final DocumentReference documentReference = mainCollection.doc('test');

class Storage {
  Future<void> storeEventData(EventInfo eventInfo) async {
  DocumentReference documentReferencer = documentReference.collection('events').doc(eventInfo.id);

  Map<String, dynamic> data = eventInfo.toJson();

  print('DATA:\n$data');

  await documentReferencer.set(data).whenComplete(() {
    print("Event added to the database, id: {${eventInfo.id}}");
  }).catchError((e) => print(e));
}


  Future<void> updateEventData(EventInfo eventInfo) async {
  DocumentReference documentReferencer = documentReference.collection('events').doc(eventInfo.id);

  Map<String, dynamic> data = eventInfo.toJson();

  print('DATA:\n$data');

  await documentReferencer.update(data).whenComplete(() {
    print("Event updated in the database, id: {${eventInfo.id}}");
  }).catchError((e) => print(e));
}


  Future<void> deleteEvent({required String id}) async {
  DocumentReference documentReferencer = documentReference.collection('events').doc(id);

  await documentReferencer.delete().catchError((e) => print(e));

  print('Event deleted, id: $id');
}


  Stream<QuerySnapshot> retrieveEvents() {
  Stream<QuerySnapshot> myClasses = documentReference.collection('events').orderBy('start').snapshots();

  return myClasses;
}
}
