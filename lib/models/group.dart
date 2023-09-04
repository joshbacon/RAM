class Group {

  static int id = 0;
  static String name = "";

  const Group.personal();

  Group(int inID, String inName) {
    id = inID;
    name = inName;
  }

  int get getID => id;
  String get getName => name;

}