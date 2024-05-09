import 'dart:core';

class HatimRoundModel {
  final int roundID;

  final List<String> userList;

  Map<String, int> userHatim = {};

  Map<String, bool> userHatimCompleted = {};

  ///Start date of the hatim round
  ///it will be assigned when the round is created by multiple the roundID
  late DateTime startDate;

  ///end date of the hatim round
  ///it will be assigned  as 1 week from the start date of the round
late DateTime endDate;
  HatimRoundModel({required this.roundID, required this.userList}) {
    ///The Duration class in Dart does not have a named parameter weeks. Instead, you can calculate the number of days in a week and use the days parameter. There are 7 days in a week, so you can multiply the roundID - 1 by 7 to get the equivalent number of days.
    startDate = DateTime.now().add(Duration(days: (roundID - 1) * 7));

    ///The endDate is calculated by adding 7 days to the startDate.
    endDate = startDate.add(Duration(days: 7));

    ///
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


  //did user complete the hatim
  bool isHatimCompleted(String userID) {
    return userHatimCompleted[userID]!;
  }

  int giveChapterNumber(int index) {
    if (index > 30) {
      return index - 30;
    } else {
      return index;
    }
  }
}
