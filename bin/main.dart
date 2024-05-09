

import 'models/models.dart';

void main(List<String> arguments) {
  GroupModel group = GroupModel(groupID: "1");
 // print(group.groupID);

  ///add users to group
  for (int i = 1; i <= 30; i++) {
    group.addUserToGroup(i.toString());
    // group.addUserToGroup(i.toString());
  }

  //set the userid for testing to "1"
  var userID = "2";


}
