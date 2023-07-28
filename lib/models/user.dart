class User{
  late int id;
  late String fullName;
  late String email;
  late String password;

  static const String tableName = "users";

  User();

  User.fromMap(Map<String, dynamic> rowMap){
   id = rowMap["id"];
   fullName = rowMap["full_name"];
   email = rowMap["email"];
   password = rowMap["password"];
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = <String,dynamic>{};
    map["full_name"] = fullName;
    map["email"] = email;
    map["password"] = password;
    return map;
  }
}