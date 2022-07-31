import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User> signInWithGoogle() async {
  final GoogleSignInAccount googleAccount = await googleSignIn.signIn() as GoogleSignInAccount;
  final GoogleSignInAuthentication googleAuthentication = await googleAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    idToken: googleAuthentication.idToken,
    accessToken: googleAuthentication.accessToken);

  final UserCredential authResult = await _auth.signInWithCredential(credential);
  final User user = authResult.user as User;

  assert(!user.isAnonymous);

  return user;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}