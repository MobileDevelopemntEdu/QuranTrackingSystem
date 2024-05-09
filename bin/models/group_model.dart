import 'dart:math';

import 'hatim_model.dart';

// group status enum
// 1- active
// 2- waiting to start
// 3- finished
enum GroupStatus { active, waiting, finished }

//group model
// group id
// list of users

class GroupModel {
  // group id
  late final String groupID;

  // hatim round (30 rounds)
  late int round;

  // list of users
  List<String> usersID = [];

  List<HatimRoundModel> hatimRounds = [];

  //stated date
  DateTime? startDate;

  late final DateTime createdDate;

  //end date
  DateTime? endDate;

  // group status
  GroupStatus status = GroupStatus.waiting;

  // constructor
  ///  when you create a either give a name or it will be generated randomly
  ///  the round will be 0 by default
  ///  the status will be waiting by default
  ///  the start date will be when  the status is active
  ///  when the status is active it will calculate the end date from that date
  ///  the created date will be the current date when the group is created

  // constructor with group name

  GroupModel({required this.groupID}) {
    round = 0;
    status = GroupStatus.waiting;
    createdDate = DateTime.now();
  }

  // constructor with random group name
  GroupModel.random() {
    groupID = generateRandomGroupID().toString();
    round = 0;
    status = GroupStatus.waiting;
    createdDate = DateTime.now();
  }

  void assignHatim() {
    if (usersID.length == 30) {
      for (int i = 0; i < 30; i++) {
        hatimRounds
            .add(HatimRoundModel(roundID: round + i, userList: usersID));
      }
    }
  }

  // set status of the group
  GroupStatus setStatus() {
    /// by default the group will be waiting
    /// if the users are 30 users then the group will be active and round will be 1
    /// if the round is more than 30 then the group will be finished
    if (usersID.isEmpty) {
      status = GroupStatus.waiting;
    } else if (usersID.length == 30 && round == 0) {
      status = GroupStatus.active;
      round = 1;
    } else if (round > 30) {
      status = GroupStatus.finished;
    } else {
      status = GroupStatus.waiting;
      round = 0;
    }

    return status;
  }

  // from json
  GroupModel.fromJson(Map<String, dynamic> json) {
    groupID = json['group_id'];
    round = json['round'];
    usersID = List<String>.from(json['users'].map((x) => x.toString()));
    status = GroupStatus.values[json['status']];
    createdDate = DateTime.parse(json['created_date']);
    startDate =
        json['start_date'] != null ? DateTime.parse(json['start_date']) : null;
    endDate =
        json['end_date'] != null ? DateTime.parse(json['end_date']) : null;
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'group_id': groupID,
      'round': round,
      'users': usersID,
      'status': status.index,
      'created_date': createdDate.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }

  void addUserToGroup(String newUser) {
    /// group has 30 user

    if (usersID.length >= 30) {
      print("You can not add more user to the group");
    } else {
      usersID.add(newUser);

      if (usersID.length == 30) {
        status = GroupStatus.active;
        round = 1;
        assignHatim();
      } else {
        if (status != GroupStatus.waiting) {
          status = GroupStatus.waiting;
        }
      }
    }
  }

  void deleteUser(String userid) {
    if (usersID.isNotEmpty) {
      if (status == GroupStatus.waiting) {
        if (usersID.contains(userid)) {
          int index = usersID.indexOf(userid);
          usersID.removeAt(index);
        }
      } else {
        print("the group is active you can not delete the user");
      }
    }
  }

  // get the available users
  int getAvailableUsers() {
    return 30 - usersID.length;
    }

  /// get the current hatim of the user
  int getCurrentHatimOfUser(String userID) {
    //empty int for count the hatim
    int count = 0;

    // Iterate over each HatimRoundModel object in the hatimRounds list
    for (HatimRoundModel hatimRound in hatimRounds) {
      // Check if the userHatim map contains the userID as a key
      if (hatimRound.userHatimCompleted.containsKey(userID)) {
        // Check if the user has completed the Hatim
        if (hatimRound.userHatimCompleted[userID] == true) {
          // If the user is in round 30 and has completed the Hatim, return 0
          if (hatimRound.roundID == 30) {
            return 30;
          }else {
            count ++;
          }
        }
      }
    }


    // If the userID is not found in any HatimRoundModel, return -1
    return count;
  }

  /// update the hatim completion status of a user
  void completeHatimOfUser(String userID) {
    //get the current hatim that is not completed of that user
    int round = getCurrentHatimOfUser(userID);
    print("round $round");

    //update that user in that round to true
    for (HatimRoundModel hatimRound in hatimRounds) {
      if (hatimRound.roundID == round) {
        hatimRound.updateHatim(userID);
      }
    }
  }

  /// get the Completed hatim of the user
  String getCompletedHatim(String userID) {
    ///check if the user is completed the hatim or not by looking at the userHatimCompleted if it is true
    ///then it will return the hatims that user completed
    ///if the user is not completed any hatim then it will return an empty string
    ///if the user is completed all the hatim then it will return "All Hatims Completed"
    List<HatimRoundModel> completedHatims = [];
    for (HatimRoundModel hatimRound in hatimRounds) {
      if (hatimRound.userHatimCompleted[userID] == true) {
        completedHatims.add(hatimRound);
      }
    }
    if (completedHatims.isEmpty) {
      return "";
    } else if (completedHatims.length == hatimRounds.length) {
      return "All Hatims Completed";
    } else {
      return completedHatims
          .map((hatimRound) => hatimRound.roundID.toString())
          .join(", ");
    }
  }

  // get all hatims of the user
  List<String> getAllHatimsOfUser(String userID) {
    ///A new empty list allHatims is created to store the Hatims of the user.
    List<String> allHatims = [];

    ///The method then iterates over each HatimRoundModel object in the hatimRounds list. hatimRounds is a list of HatimRoundModel objects, each representing a round of Hatim.
    for (HatimRoundModel hatimRound in hatimRounds) {
      ///For each HatimRoundModel object, it checks if the userHatim map contains the userID as a key. The userHatim map stores the association between a user and a Hatim.
      if (hatimRound.userHatim.containsKey(userID)) {
        ///If the userHatim map contains the userID, it adds the Hatim ID to the allHatims list.
        allHatims.add(hatimRound.userHatim[userID].toString());
      }
    }
    return allHatims;
  }

  // generate a random groupID that is max 2 numbers between 1 and 10
  static int generateRandomGroupID() {
    int id = 0;

    id = Random().nextInt(11);
    if (id > 0) {
      return id;
    } else {
      id = Random().nextInt(11);
      return id;
    }

// fake groups for test
  }
}
