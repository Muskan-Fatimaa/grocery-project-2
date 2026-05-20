// import 'package:flutter/material.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/services.dart';
//
// class SignIn extends StatefulWidget {
//   const SignIn({super.key});
//
//   @override
//   State<SignIn> createState() => _SignInState();
// }
//
// class _SignInState extends State<SignIn> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//   TextEditingController();
//
//   bool _isLogin = true;
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   String? _errorText;
//   String? _infoText;
//
//   final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
//
//   String _readableAuthError(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'invalid-email':
//         return 'Invalid email format.';
//       case 'user-disabled':
//         return 'This account has been disabled.';
//       case 'user-not-found':
//         return 'No account found with this email.';
//       case 'wrong-password':
//       case 'invalid-credential':
//         return 'Incorrect email or password.';
//       case 'email-already-in-use':
//         return 'This email is already registered. Please login.';
//       case 'weak-password':
//         return 'Password is too weak. Use at least 6 characters.';
//       case 'operation-not-allowed':
//         return 'This sign-in method is not enabled in Firebase Console.';
//       case 'network-request-failed':
//         return 'Network error. Check your internet connection.';
//       case 'too-many-requests':
//         return 'Too many attempts. Please wait a few minutes.';
//       default:
//         return 'Authentication failed (${e.code}). Please try again.';
//     }
//   }
//
//   String _readablePlatformError(PlatformException e) {
//     switch (e.code) {
//       case 'network_error':
//         return 'Network error. Check your internet connection.';
//       case 'sign_in_canceled':
//       case 'canceled':
//         return 'Sign in was cancelled.';
//       case 'sign_in_failed':
//         return 'Google sign-in failed. Make sure SHA-1 fingerprint is added in Firebase Console.';
//       default:
//         return e.message ?? 'Sign in failed. Please try again.';
//     }
//   }
//
//   Future<void> _googleSignInWithFirebase() async {
//     try {
//       await _googleSignIn.signOut();
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         _setError('Google sign in cancelled.');
//         return;
//       }
//
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//
//       if (googleAuth.idToken == null) {
//         _setError(
//           'Google setup incomplete.\n'
//               'Fix: Add SHA-1 & SHA-256 fingerprints in Firebase Console → '
//               'Project Settings → Your Android App, then redownload google-services.json.',
//         );
//         return;
//       }
//
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       final User? user = (await _auth.signInWithCredential(credential)).user;
//       if (user == null) _setError('Unable to sign in with Google.');
//
//     } on FirebaseAuthException catch (e) {
//       _setError(_readableAuthError(e));
//     } on PlatformException catch (e) {
//       if (e.message != null && e.message!.contains('ApiException: 10')) {
//         _setError(
//           'Google sign-in config error (code 10).\n'
//               'Fix: Add your SHA-1 fingerprint to Firebase Console and '
//               'redownload google-services.json.',
//         );
//       } else {
//         _setError(_readablePlatformError(e));
//       }
//     } catch (e) {
//       final String text = e.toString();
//       if (text.contains('ApiException: 10')) {
//         _setError(
//           'Google sign-in config error (code 10).\n'
//               'Fix: Add your SHA-1 fingerprint to Firebase Console and '
//               'redownload google-services.json.',
//         );
//       } else {
//         _setError('Something went wrong. Please try again.');
//       }
//     }
//   }
//
//   Future<void> _handleEmailAuth() async {
//     final String name = _nameController.text.trim();
//     final String email = _emailController.text.trim();
//     final String password = _passwordController.text;
//
//     if (!(_formKey.currentState?.validate() ?? false)) return;
//
//     try {
//       if (_isLogin) {
//         await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         // AuthGate sees user != null → shows HomeScreen automatically
//
//       } else {
//         // ── SIGNUP FIX ────────────────────────────────────────────────────
//         // Problem: createUserWithEmailAndPassword signs the user in instantly,
//         // which fires authStateChanges(user) → AuthGate shows HomeScreen briefly
//         // before signOut() completes.
//         //
//         // Solution: pause the AuthGate stream BEFORE creating the account,
//         // then sign out, then resume. We do this by storing a static flag
//         // that AuthGate checks before switching screens.
//         //
//         // Simpler approach that works reliably: set the flag on AuthGate
//         // via a global notifier before the call.
//
//         SignInNotifier.instance.setRegistering(true); // block AuthGate
//
//         final UserCredential cred = await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//
//         try {
//           await cred.user?.updateDisplayName(name);
//         } catch (_) {}
//
//         // Sign out — authStateChanges fires with null
//         await _auth.signOut();
//
//         SignInNotifier.instance.setRegistering(false); // unblock AuthGate
//
//         if (!mounted) return;
//
//         setState(() {
//           _isLogin = true;
//           _nameController.clear();
//           _passwordController.clear();
//           _confirmPasswordController.clear();
//           // Keep email filled so user doesn't retype
//         });
//
//         _setInfo('Account created! Please login with your credentials.');
//       }
//     } on FirebaseAuthException catch (e) {
//       SignInNotifier.instance.setRegistering(false);
//       _setError(_readableAuthError(e));
//     } catch (_) {
//       SignInNotifier.instance.setRegistering(false);
//       _setError('Unexpected error. Please try again.');
//     }
//   }
//
//   void _setError(String? message) {
//     if (!mounted) return;
//     setState(() {
//       _errorText = message;
//       _infoText = null;
//     });
//   }
//
//   void _setInfo(String? message) {
//     if (!mounted) return;
//     setState(() {
//       _infoText = message;
//       _errorText = null;
//     });
//   }
//
//   Future<void> _onGooglePressed() async {
//     setState(() {
//       _isLoading = true;
//       _errorText = null;
//       _infoText = null;
//     });
//     await _googleSignInWithFirebase();
//     if (!mounted) return;
//     setState(() => _isLoading = false);
//   }
//
//   Future<void> _onEmailButtonPressed() async {
//     FocusScope.of(context).unfocus();
//     setState(() {
//       _isLoading = true;
//       _errorText = null;
//       _infoText = null;
//     });
//     await _handleEmailAuth();
//     if (!mounted) return;
//     setState(() => _isLoading = false);
//   }
//
//   Future<void> _onForgotPasswordPressed() async {
//     final String email = _emailController.text.trim();
//     if (email.isEmpty || !_emailRegex.hasMatch(email)) {
//       _setError('Enter your email address first, then tap Forgot password.');
//       return;
//     }
//     setState(() {
//       _isLoading = true;
//       _errorText = null;
//       _infoText = null;
//     });
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       if (!mounted) return;
//       _setInfo('Password reset email sent to $email');
//     } on FirebaseAuthException catch (e) {
//       _setError(_readableAuthError(e));
//     } catch (_) {
//       _setError('Unexpected error. Please try again.');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//
//     final InputDecoration baseFieldDecoration = InputDecoration(
//       filled: true,
//       fillColor: const Color(0xFFF4F7F8),
//       contentPadding:
//       const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFD6DFE2)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.green.shade600, width: 1.4),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.redAccent),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
//       ),
//     );
//
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             fit: BoxFit.cover,
//             image: AssetImage('assets/myimage.png'),
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 460),
//                 child: Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width > 600 ? 28 : 20,
//                     vertical: 24,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withAlpha(235),
//                     borderRadius: BorderRadius.circular(22),
//                     border: Border.all(color: const Color(0xFFDCE4E8)),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color(0x26000000),
//                         blurRadius: 14,
//                         offset: Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         _isLogin
//                             ? 'Login to continue'
//                             : 'Create account to continue',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Color(0xFF263238),
//                           fontWeight: FontWeight.w600,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 10),
//                       const Text(
//                         'Grocify',
//                         style: TextStyle(
//                           fontSize: 40,
//                           color: Colors.green,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 26),
//
//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             if (!_isLogin) ...[
//                               TextFormField(
//                                 controller: _nameController,
//                                 textCapitalization: TextCapitalization.words,
//                                 textInputAction: TextInputAction.next,
//                                 autofillHints: const [AutofillHints.name],
//                                 validator: (value) {
//                                   if (_isLogin) return null;
//                                   if (value == null || value.trim().isEmpty) {
//                                     return 'Full name is required';
//                                   }
//                                   if (value.trim().length < 2) {
//                                     return 'Enter a valid full name';
//                                   }
//                                   return null;
//                                 },
//                                 decoration: baseFieldDecoration.copyWith(
//                                   hintText: 'Full name',
//                                   prefixIcon:
//                                   const Icon(Icons.person_outline),
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                             ],
//
//                             TextFormField(
//                               controller: _emailController,
//                               keyboardType: TextInputType.emailAddress,
//                               textInputAction: TextInputAction.next,
//                               autofillHints: const [AutofillHints.email],
//                               validator: (value) {
//                                 final String text = (value ?? '').trim();
//                                 if (text.isEmpty) return 'Email is required';
//                                 if (!_emailRegex.hasMatch(text)) {
//                                   return 'Enter a valid email';
//                                 }
//                                 return null;
//                               },
//                               decoration: baseFieldDecoration.copyWith(
//                                 hintText: 'Email address',
//                                 prefixIcon: const Icon(Icons.email_outlined),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//
//                             TextFormField(
//                               controller: _passwordController,
//                               obscureText: _obscurePassword,
//                               textInputAction: _isLogin
//                                   ? TextInputAction.done
//                                   : TextInputAction.next,
//                               autofillHints: _isLogin
//                                   ? const [AutofillHints.password]
//                                   : const [AutofillHints.newPassword],
//                               onFieldSubmitted: (_) {
//                                 if (_isLogin && !_isLoading) {
//                                   _onEmailButtonPressed();
//                                 }
//                               },
//                               validator: (value) {
//                                 final String text = value ?? '';
//                                 if (text.isEmpty) {
//                                   return 'Password is required';
//                                 }
//                                 if (text.length < 6) {
//                                   return 'Minimum 6 characters';
//                                 }
//                                 return null;
//                               },
//                               decoration: baseFieldDecoration.copyWith(
//                                 hintText: 'Password',
//                                 prefixIcon: const Icon(Icons.lock_outline),
//                                 suffixIcon: IconButton(
//                                   onPressed: () => setState(
//                                         () => _obscurePassword = !_obscurePassword,
//                                   ),
//                                   icon: Icon(
//                                     _obscurePassword
//                                         ? Icons.visibility
//                                         : Icons.visibility_off,
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             if (!_isLogin) ...[
//                               const SizedBox(height: 10),
//                               TextFormField(
//                                 controller: _confirmPasswordController,
//                                 obscureText: _obscureConfirmPassword,
//                                 textInputAction: TextInputAction.done,
//                                 autofillHints: const [
//                                   AutofillHints.newPassword,
//                                 ],
//                                 onFieldSubmitted: (_) {
//                                   if (!_isLoading) _onEmailButtonPressed();
//                                 },
//                                 validator: (value) {
//                                   if (_isLogin) return null;
//                                   if ((value ?? '').isEmpty) {
//                                     return 'Confirm your password';
//                                   }
//                                   if (value != _passwordController.text) {
//                                     return 'Passwords do not match';
//                                   }
//                                   return null;
//                                 },
//                                 decoration: baseFieldDecoration.copyWith(
//                                   hintText: 'Confirm password',
//                                   prefixIcon: const Icon(
//                                       Icons.lock_reset_outlined),
//                                   suffixIcon: IconButton(
//                                     onPressed: () => setState(
//                                           () => _obscureConfirmPassword =
//                                       !_obscureConfirmPassword,
//                                     ),
//                                     icon: Icon(
//                                       _obscureConfirmPassword
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//
//                       if (_isLogin)
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: _isLoading
//                                 ? null
//                                 : _onForgotPasswordPressed,
//                             child: Text(
//                               'Forgot password?',
//                               style: TextStyle(color: Colors.green.shade700),
//                             ),
//                           ),
//                         ),
//
//                       const SizedBox(height: 4),
//
//                       SizedBox(
//                         width: double.infinity,
//                         height: 48,
//                         child: ElevatedButton(
//                           onPressed:
//                           _isLoading ? null : _onEmailButtonPressed,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green.shade700,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: Text(_isLogin ? 'Login' : 'Sign Up'),
//                         ),
//                       ),
//
//                       const SizedBox(height: 14),
//
//                       Row(
//                         children: [
//                           Expanded(
//                               child: Divider(color: Colors.grey.shade400)),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10),
//                             child: Text(
//                               'or continue with',
//                               style: TextStyle(color: Color(0xFF546E7A)),
//                             ),
//                           ),
//                           Expanded(
//                               child: Divider(color: Colors.grey.shade400)),
//                         ],
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       SignInButton(
//                         Buttons.Google,
//                         text: 'Continue with Google',
//                         onPressed: _isLoading ? null : _onGooglePressed,
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       TextButton(
//                         onPressed: _isLoading
//                             ? null
//                             : () => setState(() {
//                           _isLogin = !_isLogin;
//                           _errorText = null;
//                           _infoText = null;
//                           _passwordController.clear();
//                           _confirmPasswordController.clear();
//                         }),
//                         child: Text(
//                           _isLogin
//                               ? "Don't have an account? Sign Up"
//                               : 'Already have an account? Login',
//                           style: TextStyle(color: Colors.green.shade700),
//                         ),
//                       ),
//
//                       if (_errorText != null) ...[
//                         const SizedBox(height: 6),
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.red.shade50,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.red.shade200),
//                           ),
//                           child: Text(
//                             _errorText!,
//                             style: TextStyle(
//                                 color: Colors.red.shade800, fontSize: 13),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ],
//
//                       if (_infoText != null) ...[
//                         const SizedBox(height: 6),
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.green.shade200),
//                           ),
//                           child: Text(
//                             _infoText!,
//                             style: TextStyle(
//                                 color: Colors.green.shade800, fontSize: 13),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ],
//
//                       if (_isLoading)
//                         const Padding(
//                           padding: EdgeInsets.only(top: 12),
//                           child: CircularProgressIndicator(),
//                         ),
//
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── SignInNotifier ─────────────────────────────────────────────────────────────
// // A tiny singleton that AuthGate listens to.
// // When registering=true, AuthGate ignores the auth stream and shows a loader,
// // preventing the HomeScreen flash during signup → signOut sequence.
//
// class SignInNotifier extends ChangeNotifier {
//   SignInNotifier._();
//   static final SignInNotifier instance = SignInNotifier._();
//
//   bool _registering = false;
//   bool get registering => _registering;
//
//   void setRegistering(bool value) {
//     if (_registering == value) return;
//     _registering = value;
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorText;
  String? _infoText;

  final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  // ── Error helpers ──────────────────────────────────────────────────────────

  String _readableAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'This email is already registered. Please login.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase Console.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a few minutes.';
      default:
        return 'Authentication failed (${e.code}). Please try again.';
    }
  }

  String _readablePlatformError(PlatformException e) {
    switch (e.code) {
      case 'network_error':
        return 'Network error. Check your internet connection.';
      case 'sign_in_canceled':
      case 'canceled':
        return 'Sign in was cancelled.';
      case 'sign_in_failed':
        return 'Google sign-in failed. Make sure SHA-1 fingerprint is added in Firebase Console.';
      default:
        return e.message ?? 'Sign in failed. Please try again.';
    }
  }

  // ── Google sign-in ─────────────────────────────────────────────────────────

  Future<void> _googleSignInWithFirebase() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setError('Google sign in cancelled.');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      if (googleAuth.idToken == null) {
        _setError(
          'Google setup incomplete.\n'
              'Fix: Add SHA-1 & SHA-256 fingerprints in Firebase Console → '
              'Project Settings → Your Android App, then redownload google-services.json.',
        );
        return;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final User? user =
          (await _auth.signInWithCredential(credential)).user;
      if (user == null) _setError('Unable to sign in with Google.');
      // AuthGate StreamBuilder fires → HomeScreen automatically

    } on FirebaseAuthException catch (e) {
      _setError(_readableAuthError(e));
    } on PlatformException catch (e) {
      if (e.message != null && e.message!.contains('ApiException: 10')) {
        _setError(
          'Google sign-in config error (code 10).\n'
              'Fix: Add your SHA-1 fingerprint to Firebase Console and '
              'redownload google-services.json.',
        );
      } else {
        _setError(_readablePlatformError(e));
      }
    } catch (e) {
      final String text = e.toString();
      if (text.contains('ApiException: 10')) {
        _setError(
          'Google sign-in config error (code 10).\n'
              'Fix: Add your SHA-1 fingerprint to Firebase Console and '
              'redownload google-services.json.',
        );
      } else {
        _setError('Something went wrong. Please try again.');
      }
    }
  }

  // ── Email auth ─────────────────────────────────────────────────────────────

  Future<void> _handleEmailAuth() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      if (_isLogin) {
        // ── LOGIN — AuthGate handles navigation automatically ──────────────
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // ── SIGNUP ──────────────────────────────────────────────────────────
        //
        // FIX: Set registering=true BEFORE createUser so AuthGate is blocked
        // for the entire operation — including the moment Firebase auto-signs
        // the user in after account creation. This prevents the brief flash
        // to HomeScreen that happened when setRegistering was called after.
        //
        // The SignIn screen stays fully visible throughout because _isLoading
        // keeps the spinner inside this form. Only AuthGate is blocked.

        SignInNotifier.instance.setRegistering(true);

        try {
          final UserCredential cred =
          await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          try {
            await cred.user?.updateDisplayName(name);
          } catch (_) {}

          await _auth.signOut();
        } finally {
          // Always unblock AuthGate — even if an exception was thrown.
          // At this point user==null so AuthGate stays on SignIn screen.
          SignInNotifier.instance.setRegistering(false);
        }

        if (!mounted) return;

        setState(() {
          _isLogin = true;
          _nameController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          // Keep email filled so the user doesn't have to retype it
        });

        _setInfo('Account created! Please login with your credentials.');
      }
    } on FirebaseAuthException catch (e) {
      SignInNotifier.instance.setRegistering(false);
      _setError(_readableAuthError(e));
    } catch (_) {
      SignInNotifier.instance.setRegistering(false);
      _setError('Unexpected error. Please try again.');
    }
  }

  // ── State helpers ──────────────────────────────────────────────────────────

  void _setError(String? message) {
    if (!mounted) return;
    setState(() {
      _errorText = message;
      _infoText = null;
    });
  }

  void _setInfo(String? message) {
    if (!mounted) return;
    setState(() {
      _infoText = message;
      _errorText = null;
    });
  }

  // ── Button handlers ────────────────────────────────────────────────────────

  Future<void> _onGooglePressed() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
      _infoText = null;
    });
    await _googleSignInWithFirebase();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _onEmailButtonPressed() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorText = null;
      _infoText = null;
    });
    await _handleEmailAuth();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _onForgotPasswordPressed() async {
    final String email = _emailController.text.trim();
    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      _setError('Enter your email address first, then tap Forgot password.');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorText = null;
      _infoText = null;
    });
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      _setInfo('Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      _setError(_readableAuthError(e));
    } catch (_) {
      _setError('Unexpected error. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final InputDecoration baseFieldDecoration = InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF4F7F8),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD6DFE2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green.shade600, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    );

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/myimage.png'),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width > 600 ? 28 : 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(235),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFDCE4E8)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Title ──────────────────────────────────────────
                      Text(
                        _isLogin
                            ? 'Login to continue'
                            : 'Create account to continue',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF263238),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Grocify',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 26),

                      // ── Form ───────────────────────────────────────────
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Name field (signup only)
                            if (!_isLogin) ...[
                              TextFormField(
                                controller: _nameController,
                                textCapitalization:
                                TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.name],
                                validator: (value) {
                                  if (_isLogin) return null;
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return 'Full name is required';
                                  }
                                  if (value.trim().length < 2) {
                                    return 'Enter a valid full name';
                                  }
                                  return null;
                                },
                                decoration: baseFieldDecoration.copyWith(
                                  hintText: 'Full name',
                                  prefixIcon:
                                  const Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],

                            // Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              validator: (value) {
                                final String text =
                                (value ?? '').trim();
                                if (text.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!_emailRegex.hasMatch(text)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                              decoration: baseFieldDecoration.copyWith(
                                hintText: 'Email address',
                                prefixIcon:
                                const Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: _isLogin
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                              autofillHints: _isLogin
                                  ? const [AutofillHints.password]
                                  : const [AutofillHints.newPassword],
                              onFieldSubmitted: (_) {
                                if (_isLogin && !_isLoading) {
                                  _onEmailButtonPressed();
                                }
                              },
                              validator: (value) {
                                final String text = value ?? '';
                                if (text.isEmpty) {
                                  return 'Password is required';
                                }
                                if (text.length < 6) {
                                  return 'Minimum 6 characters';
                                }
                                return null;
                              },
                              decoration: baseFieldDecoration.copyWith(
                                hintText: 'Password',
                                prefixIcon:
                                const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                        () => _obscurePassword =
                                    !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                            ),

                            // Confirm password (signup only)
                            if (!_isLogin) ...[
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [
                                  AutofillHints.newPassword,
                                ],
                                onFieldSubmitted: (_) {
                                  if (!_isLoading) {
                                    _onEmailButtonPressed();
                                  }
                                },
                                validator: (value) {
                                  if (_isLogin) return null;
                                  if ((value ?? '').isEmpty) {
                                    return 'Confirm your password';
                                  }
                                  if (value !=
                                      _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                decoration: baseFieldDecoration.copyWith(
                                  hintText: 'Confirm password',
                                  prefixIcon: const Icon(
                                      Icons.lock_reset_outlined),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(
                                          () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                    ),
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // ── Forgot password ────────────────────────────────
                      if (_isLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isLoading
                                ? null
                                : _onForgotPasswordPressed,
                            child: Text(
                              'Forgot password?',
                              style:
                              TextStyle(color: Colors.green.shade700),
                            ),
                          ),
                        ),

                      const SizedBox(height: 4),

                      // ── Login / Sign Up button ─────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                          _isLoading ? null : _onEmailButtonPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(_isLogin ? 'Login' : 'Sign Up'),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── Divider ────────────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                              child:
                              Divider(color: Colors.grey.shade400)),
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'or continue with',
                              style:
                              TextStyle(color: Color(0xFF546E7A)),
                            ),
                          ),
                          Expanded(
                              child:
                              Divider(color: Colors.grey.shade400)),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ── Google sign-in ─────────────────────────────────
                      SignInButton(
                        Buttons.Google,
                        text: 'Continue with Google',
                        onPressed: _isLoading ? null : _onGooglePressed,
                      ),

                      const SizedBox(height: 10),

                      // ── Toggle login / signup ──────────────────────────
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => setState(() {
                          _isLogin = !_isLogin;
                          _errorText = null;
                          _infoText = null;
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                        }),
                        child: Text(
                          _isLogin
                              ? "Don't have an account? Sign Up"
                              : 'Already have an account? Login',
                          style:
                          TextStyle(color: Colors.green.shade700),
                        ),
                      ),

                      // ── Error banner ───────────────────────────────────
                      if (_errorText != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border:
                            Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            _errorText!,
                            style: TextStyle(
                                color: Colors.red.shade800,
                                fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],

                      // ── Info banner ────────────────────────────────────
                      if (_infoText != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.green.shade200),
                          ),
                          child: Text(
                            _infoText!,
                            style: TextStyle(
                                color: Colors.green.shade800,
                                fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],

                      // ── Loading spinner ────────────────────────────────
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: CircularProgressIndicator(),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SignInNotifier
//
// Singleton flag watched by AuthGate.
//
// Set to true BEFORE createUserWithEmailAndPassword so AuthGate is blocked
// for the entire signup flow — including the moment Firebase auto-signs the
// new user in. This prevents AuthGate from briefly routing to HomeScreen.
//
// The SignIn screen stays fully visible throughout because _isLoading=true
// keeps the spinner inside the form. Only AuthGate routing is blocked.
//
// The finally block in _handleEmailAuth guarantees setRegistering(false) is
// always called, even if an exception is thrown mid-signup.
// ─────────────────────────────────────────────────────────────────────────────
class SignInNotifier extends ChangeNotifier {
  SignInNotifier._();
  static final SignInNotifier instance = SignInNotifier._();

  bool _registering = false;
  bool get registering => _registering;

  void setRegistering(bool value) {
    if (_registering == value) return;
    _registering = value;
    notifyListeners();
  }
}