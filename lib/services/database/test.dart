import 'package:cloud_firestore/cloud_firestore.dart';

class RevathiStores
{
  CollectionReference _reference = Firestore.instance.collection('user');

  getData()
  async {
    print((await _reference.document('I1Qk4xVIiP9GjVJB2I8I').get()).data);
  }
}