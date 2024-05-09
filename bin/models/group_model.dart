import 'dart:math';

import 'hatim_model.dart';

/// group status enum
// 1- active
// 2- waiting to start
// 3- finished
enum GroupStatus { active, waiting, finished }

/// group model
class GroupModel {
  /// group id
  late final String groupID;

  /// The General hatim round (30 rounds )
  late int round;

  /// list of users
  List<String> usersID = [];

  /// list of hatim rounds (30 rounds)
  List<HatimRoundModel> hatimRounds = [];

  ///stated date
  /// if the group is active then the start date will be the current date
  DateTime? startDate;

  late final DateTime createdDate;

  ///end date
  /// if the group is active then the end date will be the start date + 30 weeks
  DateTime? endDate;

  /// group status
  /// by default the group will be waiting
  /// if the users are 30 users then the group will be active and round will be 1
  /// if the round is more than 30 then the group will be finished
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
  GroupModel.randomID() {
    groupID = generateRandomGroupID().toString();
    round = 0;
    status = GroupStatus.waiting;
    createdDate = DateTime.now();
  }

  void _assignHatim() {
    if (usersID.length == 30) {
      for (int i = 0; i < 30; i++) {
        hatimRounds.add(HatimRoundModel(roundID: round + i, userList: usersID));
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

  ///write by Mohammed
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

  ///write by Mohammed
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

  ///write by Cengizhan
  /// add user to group
  ///  ---------- Rules ----------
  ///  ----------Active Status----------
  /// if the group has 30 users then the group will be active
  /// if the group is active then the start date will be the current date
  /// if the group is active then the end date will be the start date + 30 weeks
  /// if the group is active then the round will be 1
  ///  ----------Waiting Status----------
  ///  if the group is less then 30 user the status will be waiting and can add more users
  ///  the round still 0
  void addUserToGroup(String newUser) {

/// check if  the users is already in the group
    if (usersID.length >= 30) {
      /// if the user is more than 30  in the group then it will not add  any new  user
      print("You can not add more user to the group");
    } else {
      /// if the user is less than 30  in the group then it will add  new  user
      usersID.add(newUser);

      /// if the users become 30 then the group will be active and stop taking new users
      if (usersID.length == 30) {
        ///status will be active
        status = GroupStatus.active;
        ///round will be 1
        round = 1;
        ///startDate will be the current date
        startDate = DateTime.now();
        ///endDate will be the startDate + 30 weeks
       endDate = startDate!.add(Duration(days: 30 * 7));
       ///assign the hatim to the users
        _assignHatim();

      } else {
        /// if the users is less than 30 then the group will be waiting
        if (status != GroupStatus.waiting) {
          status = GroupStatus.waiting;
        }

      }
    }
  }

  ///write by Cengizhan
  /// delete user from group
  void deleteUser(String userid) {

    if (usersID.isNotEmpty) {
      ///check if the group is not empty
      if (status == GroupStatus.waiting) {
        ///check if the group is waiting so it can delete the user from the group
        if (usersID.contains(userid)) {
          ///check if the user is in the group

          ///get the index of the user
          int index = usersID.indexOf(userid);

          ///remove the user from the group
          usersID.removeAt(index);
        }
      } else {
        ///if the group is active then it can not delete the user
        print("the group is active you can not delete the user");
      }
    }
  }

  ///write by Mohammed
  /// get the available users
  int getHowMuchLeftPlaceInTheGroup() {
    return 30 - usersID.length;
    }

  ///write by Mohammed And Cengizhan
  /// get the current hatim of the user
  int getCurrentHatimOfUser(String userID) {
    //empty int for count the hatim
    int count = 1;

    // Iterate over each HatimRoundModel object in the hatimRounds list
    for (HatimRoundModel hatimRound in hatimRounds) {
      // Check if the userHatim map contains the userID as a key
      if (hatimRound.userHatimCompleted.containsKey(userID)) {
        //print(hatimRound.userHatimData(userID));
        // Check if the user has completed the Hatim
        if (hatimRound.isHatimCompleted(userID) == true) {
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

  ///Write by Mohammed
  /// update the hatim completion status of a user
  void completeHatimOfUser(String userID) {
    //get the current hatim that is not completed of that user
    int round = getCurrentHatimOfUser(userID);
   // print("round $round");

    //update that user in that round to true
    for (HatimRoundModel hatimRound in hatimRounds) {
      if (hatimRound.roundID == round) {
        hatimRound.updateHatim(userID);
      }
    }
  }

  /*

    // //Iterate over each HatimRoundModel object in the hatimRounds list
    // for (HatimRoundModel hatimRound in hatimRounds) {
    //   //Check if the roundID is equal to the roundID of the HatimRoundModel object
    //   if (hatimRound.roundID == roundID) {
    //     //Iterate over each user in the userHatimCompleted map
    //     for (var user in hatimRound.userHatimCompleted.keys) {
    //       //Check if the user has completed the Hatim
    //       if (hatimRound.userHatimCompleted[user] == true) {
    //         //Add the user to the userList list
    //         userList.add(user);
    //       }
    //     }
    //   }
    // }
   */
  ///Write by Mohammed
  /// get the completed hatims of  the round
  ///  In this method, it will take the roundID as inout to get all the users who have completed the round.
  List<String> getCompletedHatim(int roundID) {
    List<String> userList = [];

    hatimRounds.where((hatimRound) => hatimRound.roundID == roundID).forEach((userHatim) {
      userHatim.userHatimCompleted.forEach((key, value) {
        if (value == true) {
          userList.add(key);
        }
      });
    });
    return userList;
  }

  ///Write by Mohammed
  /// get the not completed hatims of  the round
  ///  In this method, it will take the roundID as inout to get all the users who have not completed the round.
  List<String> getNotCompletedHatim(int roundID) {
    List<String> userList = [];

    hatimRounds.where((hatimRound) => hatimRound.roundID == roundID).forEach((userHatim) {
      userHatim.userHatimCompleted.forEach((key, value) {
        if (value == false) {
          userList.add(key);
        }
      });
    });
    return userList;
  }

/// Write by Mohammed
  /// How Many days left for the group to finish
  /// This method will calculate the number of days left for the group to finish.
  int getDaysLeft() {
    if (status == GroupStatus.active) {
      return endDate!.difference(DateTime.now()).inDays;
    } else {
      return 0;
    }
  }


  /// Write by Mohammed
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

  List<String> getNotCopleatedHatimRoundsOfUser(String userID){
    List<String> complated = [];

    for (HatimRoundModel hatimRound in hatimRounds) {
      if (hatimRound.userHatimCompleted.containsKey(userID)) {
        if (hatimRound.userHatimCompleted[userID] == false){
          complated.add(hatimRound.roundID.toString());
        }
      }

    }
    return complated;
  }


  List<String> getCopleatedHatimRoundsOfUser(String userID){
    List<String> complated = [];

    for (HatimRoundModel hatimRound in hatimRounds) {
      if (hatimRound.userHatimCompleted.containsKey(userID)) {
        if (hatimRound.userHatimCompleted[userID] == true){
          complated.add(hatimRound.roundID.toString());
        }
      }

    }
    return complated;
  }

   List<String> getCopleatedHatimChatersOfUser(String userID){
    List<String> complated = [];

    for (HatimRoundModel hatimRound in hatimRounds) {
      if (hatimRound.userHatimCompleted.containsKey(userID)) {
        if (hatimRound.userHatimCompleted[userID] == true){
          complated.add(hatimRound.userHatim[userID].toString());
        }
      }

    }
    return complated;
  }

  ///Write by Cengizhan
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


  }
}
