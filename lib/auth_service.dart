import 'dart:async';

import 'package:emart/utils/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthService {

  Future<User?> signInWithGoogle() async {

    User? user;

// Trigger the authentication flow
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      user = userCredential.user;

      if((userCredential.additionalUserInfo?.isNewUser) ?? false){
        var ref = FirebaseDatabase.instance
            .ref()
            .child('users/${_auth.currentUser?.uid}');
        await ref.set({
          "name": _auth.currentUser?.displayName.toString(),
          "email": _auth.currentUser?.email.toString(),
          "uid": _auth.currentUser?.uid.toString(),
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        UiUtils.showToast(
            'The account already exists with a different credential.');
      } else if (e.code == 'invalid-credential') {
        UiUtils.showToast(
            'Error occurred while accessing credentials. Try again.');
      }
    } catch (e) {
      UiUtils.showToast('Error occurred using Google Sign-In. Try again.');
    }

    return user;
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    UiUtils.showToast('Logged Out Successfully');
  }
}
