import 'models/models.dart';

void main(List<String> arguments) {
  GroupModel group = GroupModel(groupID: "0");
  // print(group.groupID);

  ///add users to group
  for (int i = 1; i <= 30; i++) {
    group.addUserToGroup(i.toString());
  }

  //set the userid for testing to "1"
  var userID = "2";
  //print(group.getCurrentHatimOfUser(userID));
  for (int i = 1; i <= 15; i++) {
    group.completeHatimOfUser(i.toString());

  }

  print(group.getCompletedHatim(1));
  print(group.getNotCompletedHatim(1));
  //print(group.getCurrentHatimOfUser(userID));
}
