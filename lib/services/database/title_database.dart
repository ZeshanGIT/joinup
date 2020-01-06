import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joinup/models/title_model.dart';

class TitleDatabase {
  String title;
  TitleDatabase(this.title);
  CollectionReference _titleCollection = Firestore.instance.collection('title');

  Future addTitle() async {
    return _titleCollection.add({
      'title': title,
      'titleKey': title.toLowerCase(),
      'numOfUses': 0,
      'key': title.toLowerCase().split(' '),
    });
  }

  Future incrementTitleUse(String docid) {
    _titleCollection.where('');
  }

  Future<List<TitleModel>> searchTitle() async {
    List<DocumentSnapshot> docs1 = (await _titleCollection
            .where('key', arrayContainsAny: title.split(' '))
            .limit(5)
            .getDocuments())
        .documents;
    List<DocumentSnapshot> docs2;
    if (title.replaceAll(' ', '').isNotEmpty) {
      docs2 = (await _titleCollection
              .where('titleKey', isGreaterThanOrEqualTo: title)
              .where(
                'titleKey',
                isLessThan: String.fromCharCodes(
                  (title.codeUnits.map((cu) => cu + 1).toList()),
                ),
              )
              .limit(5)
              .getDocuments())
          .documents;
    } else {
      docs2 = (await _titleCollection
              .where('titleKey', isGreaterThanOrEqualTo: title)
              .limit(5)
              .getDocuments())
          .documents;
    }

    List<Map<String, dynamic>> result = [];

    result = docs1.map(_mapFromDocSnap).toList();

    result.addAll(docs2.map((val) {
      List titles = result.map((f) => f['title']).toList();
      if (titles.contains(val.data['title'])) {
        return null;
      }
      return _mapFromDocSnap(val);
    }).toList());
    result.removeWhere((item) => item == null);
    result.sort((a, b) {
      String tempA = a['titleKey'];
      String tempB = b['titleKey'];
      print('\n#######');
      print('$tempA\t$tempB');
      print(title);
      print(_compareString(tempA, tempB));
      print('-------\n\n');
      return _compareString(tempA, tempB);
      // if (tempA.startsWith(title)) {
      //   print('Yaaaaas');
      //   print('$tempA starts with $title');
      //   print('%%%%%%\n\n');
      //   return -1;
      // } else {
      //   String titleKey = a['titleKey'];
      //   print('Nooooooooo');
      //   print('$tempA does not start with $title');
      //   print('Title Key : $titleKey');
      //   if (titleKey.contains(tempA)) {
      //     return 0;
      //   }
      //   return 1;
      // }
    });
    return result
        .map((title) => TitleModel(title['title'], title['numOfUses']))
        .toList();
  }

  int _compareString(String tempA, String tempB) {
    List<int> aCU = tempA.codeUnits;
    List<int> bCU = tempB.codeUnits;
    int score = 0;
    int len = aCU.length;
    if (aCU.length > bCU.length) {
      List<int> temp = aCU;
      aCU = bCU;
      bCU = temp;
      len = bCU.length;
    }

    for (int i = 0; i < aCU.length; i++) {
      score += (len - i) ^ 2 * (aCU[i] == bCU[i] ? -1 : 1);
    }

    return ((score / len) * 100).round();
  }

  Map<String, dynamic> _mapFromDocSnap(val) => val.data;

  List<TitleModel> _titleListFromQuerySnapshot(QuerySnapshot qss) {}

  TitleModel _titleFromDocSnapshot(DocumentSnapshot f) {
    // print('Title : ${f.data['title']}\nNum : ${f.data['numOfUses']}');
    return TitleModel(f.data['title'], f.data['numOfUses']);
  }
}
