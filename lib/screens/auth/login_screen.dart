import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vp18_data_app/database/controllers/user_db_controller.dart';
import 'package:vp18_data_app/models/process_response.dart';
import 'package:vp18_data_app/provider/language_provider.dart';
import 'package:vp18_data_app/utils/context_extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;

  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  String? _emailError;
  String? _passwordError;

  String? _language;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _showLanguageBottomSheet(),
            icon: const Icon(Icons.language, size: 26),
            color: Colors.black,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 30, top: 100, end: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localizations.sing_in,
                style: GoogleFonts.nunito(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.localizations.sing_in_hint,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF716F87),
                ),
              ),
              const SizedBox(height: 37),
              TextField(
                controller: _emailTextController,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.send,
                cursorColor: Colors.black,
                cursorHeight: 30,
                cursorWidth: 1,
                decoration: InputDecoration(
                  hintText: context.localizations.email_hint,
                  hintMaxLines: 1,
                  errorText: _emailError,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _passwordTextController,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.send,
                cursorColor: Colors.black,
                cursorHeight: 30,
                cursorWidth: 1,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: context.localizations.password_hint,
                  hintMaxLines: 1,
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() => _obscure = !_obscure);
                    },
                    color: Colors.grey,
                  ),
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => _performLogin(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF6A90F2),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  minimumSize: const Size(double.infinity, 53),
                ),
                child: Text(
                  context.localizations.login,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.localizations.no_account,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF716F87),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/sign_up_screen'),
                    child: Text(
                      context.localizations.create_now,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performLogin() {
    if (_checkData()) {
      _login();
    }
  }

  bool _checkData() {
    _controlErrors();
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    context.showSnackBar(
        message: context.localizations.insert_required_data, erorr: true);
    return false;
  }

  void _controlErrors() {
    setState(() {
      _emailError = _emailTextController.text.isEmpty
          ? context.localizations.insert_email_address
          : null;
      _passwordError = _passwordTextController.text.isEmpty
          ? context.localizations.insert_password
          : null;
    });
  }

  void _login() async{
    ProcessResponse processResponse = await UserDbController().login(_emailTextController.text, _passwordTextController.text);

    context.showSnackBar(message: processResponse.message, erorr: !processResponse.success);
    if(processResponse.success) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  void _showLanguageBottomSheet() async {
    String? result = await showModalBottomSheet<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          backgroundColor: Colors.transparent,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localizations.language_hint,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        context.localizations.language_massage,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black45,
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'English',
                          style: GoogleFonts.roboto(),
                        ),
                        value: 'en',
                        groupValue: _language,
                        onChanged: (String? value) {
                          setState(() => _language = value);
                          Navigator.pop(context, 'en');
                        },
                        visualDensity: const VisualDensity(
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'العربية',
                          style: GoogleFonts.roboto(),
                        ),
                        value: 'ar',
                        groupValue: _language,
                        onChanged: (String? value) {
                          setState(() => _language = value);
                          Navigator.pop(context, 'ar');
                        },
                        visualDensity: const VisualDensity(
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
    if (result != null) {
      // TODO: Change Language
      Provider.of<LanguageProvider>(context, listen: false)
          .changeLanguage(result);
    }
  }
}
