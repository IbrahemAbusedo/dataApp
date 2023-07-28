import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp18_data_app/pref/shared_pref_controller.dart';

class Launch extends StatefulWidget {
  const Launch({Key? key}) : super(key: key);

  @override
  State<Launch> createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {

  @override
  void initState() {
    super.initState();

    bool loggedIn = SharedPrefController().getValue<bool>(PrefKeys.loggedIn.name) ?? false;
    String route = loggedIn ? "/main" : "/login";

    Future.delayed(const Duration(seconds: 3),(){
      Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:  Text('Data App',style: GoogleFonts.poppins(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),),
      ),
    );
  }
}
