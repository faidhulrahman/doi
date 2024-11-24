
import 'package:cash_compass/helpers/constants.dart';
import 'package:cash_compass/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: customColorPrimary),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                child: Image(
                  image: AssetImage('assets/images/fingerprint.png'),
                  width: 148,
                  height: 160,
                  color: Colors.white,
                ),
                onTap: () => _authenticateWithBiometrics(),
              ),
              const SizedBox(
                height: 48,
              ),
              Text(
                "Fingerprint Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }


Future<void> _authenticateWithBiometrics() async {
  bool isBiometricAvailable = false;
  List<BiometricType> availableBiometrics = [];

  try {
    // Cek apakah perangkat mendukung biometrik
    isBiometricAvailable = await auth.canCheckBiometrics;

    if (!isBiometricAvailable) {
      print("Biometric is not available on this device.");
      return;
    }

    // Dapatkan daftar biometrik yang tersedia
    availableBiometrics = await auth.getAvailableBiometrics();
    print("Available Biometrics: $availableBiometrics");

    // Autentikasi dengan biometrik
    bool isAuthenticated = await auth.authenticate(
      localizedReason: "Scan your fingerprint to authenticate",
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    if (isAuthenticated) {
      print("Authentication successful!");
      // Aksi setelah berhasil login, misalnya navigasi ke halaman lain
      _navigateToHomeScreen();
    } else {
      print("Authentication failed.");
    }
  } catch (e) {
    print("Error during biometric authentication: $e");
  }
}

void _navigateToHomeScreen() {
  // Contoh navigasi setelah berhasil login
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MainScreen()),
  );
}

}