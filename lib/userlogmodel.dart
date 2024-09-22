import 'package:hive/hive.dart';
part 'userlogmodel.g.dart';

@HiveType(typeId:2)
class UserDetails extends HiveObject{

  @HiveField(0)
  String user_phone;

  @HiveField(1)
  String user_type;

  @HiveField(2)
  bool user_logout;

  @HiveField(3)
  String userHospitalNow;

  @HiveField(4)
  String userName;

  UserDetails({required this.user_phone,required this.user_type, required this.user_logout,required this.userHospitalNow,required this.userName});
}