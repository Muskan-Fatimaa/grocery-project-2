
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/auth/sign_in.dart'; // also imports SignInNotifier
import 'package:grocery_app/services/firestore_service.dart';
import 'package:grocery_app/providers/avatar_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => AvatarProvider()),
        ChangeNotifierProvider.value(value: SignInNotifier.instance),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffe07b39),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

/// Watches Firebase auth state AND the SignInNotifier flag.
///
/// Login  → saveUserProfile() → start providers → HomeScreen
/// Logout → stop providers → SignIn
/// Signup in progress → show loader (blocks HomeScreen flash)
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _providersStarted = false;

  void _startProviders() {
    if (_providersStarted) return;
    _providersStarted = true;
    context.read<CartProvider>().startListening();
    context.read<WishlistProvider>().startListening();

    // Save/update user profile in Firestore on every login.
    // Uses merge:true so it's safe to call repeatedly — won't overwrite data.
    FirestoreService().saveUserProfile().catchError((_) {
      // Non-critical — ignore errors silently
    });
  }

  void _stopProviders() {
    if (!_providersStarted) return;
    _providersStarted = false;
    context.read<CartProvider>().reset();
    context.read<WishlistProvider>().reset();
  }

  @override
  Widget build(BuildContext context) {
    // While signup + signOut is in progress, show loader to block HomeScreen flash
    final bool registering = context.watch<SignInNotifier>().registering;

    if (registering) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xffe07b39)),
        ),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xffe07b39)),
            ),
          );
        }

        final User? user = snapshot.data;

        if (user != null) {
          _startProviders();
          // ✅ No const here — HomeScreen uses providers so cannot be const
          return HomeScreen();
        }

        _stopProviders();
        // ✅ No const here — SignIn uses FirebaseAuth so cannot be const
        return SignIn();
      },
    );
  }
}