///User Model
///
/// Each user will have a phone number and a name
/// Each user will have a list of hatim groups
library;

class UserModel {
  late final String id;
  final String name;
  String phoneNumber;
  final bool?  isAdmin;
  // map of groupsID and int of the current chapter
  final Map<String, dynamic>? groups;


  UserModel({
    required this.name,
    required this.phoneNumber,
    this.isAdmin = false,
    this.groups,
  }){
    id = processPhoneNumber(phoneNumber);
  }

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        phoneNumber = json['phoneNumber'],
        isAdmin = json['isAdmin'],
        groups = json['groups'] as Map<String, dynamic> ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = processPhoneNumber(phoneNumber);
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['isAdmin'] = isAdmin ?? false;
    data['groups'] = groups ?? {};
    return data;
  }

  // process phone number static function
  static String processPhoneNumber(String phoneNumber) {
    // Remove all spaces, "+" and "-" characters
    String processedNumber = phoneNumber.replaceAll(RegExp(r"[\s+-]"), "");

    // Remove leading "0" if it exists
    if (processedNumber.startsWith("0")) {
      processedNumber = processedNumber.substring(1);
    }

    return processedNumber;
  }

  // is phone number the same
  bool isEqual(String phoneNumber) {
    if (this.phoneNumber == phoneNumber) {
      return true;
    }
    return false;
  }

  //if the current user has group
  bool isInTheGroups(String groupID) {
    if (groups != null && groups!.containsKey(groupID)) {
      return true;
    } else {
      return false;
    }
  }


  bool hasGroup(String groupID) {
    if (groups!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
    }
}
