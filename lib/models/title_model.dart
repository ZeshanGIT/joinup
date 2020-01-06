class TitleModel {
  final String title;
  final int numOfUses;

  TitleModel(this.title, this.numOfUses);
  @override
  String toString() {
    return '''Title : "$title"\tNum of Uses : $numOfUses''';
  }
}
