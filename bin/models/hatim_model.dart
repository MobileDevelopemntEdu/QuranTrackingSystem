

import 'dart:core';

class HatimRoundModel {
  final int roundID;

  final List<String> userList;

  Map<String, int> userHatim = {};

  Map<String, bool> userHatimCompleted = {};

  HatimRoundModel({required this.roundID, required this.userList}) {
    _assignHatim();
  }

  void _assignHatim() {
    for (var element in userList) {
      int index = userList.indexOf(element);
      userHatim[element] = giveChapterNumber(index + roundID);
      userHatimCompleted[element] = false;
    }
  }

  // update
  void updateHatim(String userID) {
    if (userHatimCompleted[userID] == false) {
      userHatimCompleted[userID] = true;
    }
  }

  // get user data map<hatimID,isCompleted > of that user
  Map<String, bool> userHatimData(String userID) {
    return {userHatim[userID].toString(): userHatimCompleted[userID]!};
  }

  int giveChapterNumber(int index) {
    if (index > 30) {
      return index - 30;
    } else {
      return index;
    }
  }
}
