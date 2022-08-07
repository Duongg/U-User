import 'package:firebase_auth/firebase_auth.dart';
import 'package:u_user/model/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentFirebaseUser;
UserModel? userModelCurrentInfo;