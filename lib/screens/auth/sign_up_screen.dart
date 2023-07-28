import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vp18_data_app/database/controllers/user_db_controller.dart';
import 'package:vp18_data_app/models/process_response.dart';
import 'package:vp18_data_app/models/user.dart';
import 'package:vp18_data_app/utils/context_extension.dart';
import '../../provider/language_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscure = true;

  late TextEditingController _fullNameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;

  String? _language;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fullNameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 25),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        actions: [
          IconButton(
            onPressed: () => _showLanguageBottomSheet(),
            icon: const Icon(
              Icons.language,
              size: 26,
            ),
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 30, end: 30, top: 60),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localizations.sign_up,
                style: GoogleFonts.nunito(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.localizations.register,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF716F87),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _fullNameTextController,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.send,
                cursorColor: Colors.black,
                cursorHeight: 30,
                cursorWidth: 1,
                decoration: InputDecoration(
                  hintText: context.localizations.full_name,
                  hintMaxLines: 1,
                  errorText: _fullNameError,
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
              const SizedBox(height: 18),
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
              const SizedBox(height: 18),
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
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _performRegister(),
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
                child: Text(context.localizations.sign_up),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performRegister() {
    if (_checkData()) {
      _register();
    }
  }

  bool _checkData() {
    _controlErrors();
    if (_fullNameTextController.text.isNotEmpty &&
        _emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    context.showSnackBar(
        message: context.localizations.insert_required_data, erorr: true);
    return false;
  }

  void _controlErrors() {
    setState(() {
      _fullNameError = _fullNameTextController.text.isEmpty
          ? context.localizations.insert_full_name
          : null;
      _emailError = _emailTextController.text.isEmpty
          ? context.localizations.insert_email_address
          : null;
      _passwordError = _passwordTextController.text.isEmpty
          ? context.localizations.insert_password
          : null;
    });
  }

  void _register() async {
    ProcessResponse processResponse = await UserDbController().register(user);
    context.showSnackBar(
        message: processResponse.message, erorr: !processResponse.success);
    if (processResponse.success) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  User get user {
    User user = User();
    user.fullName = _fullNameTextController.text;
    user.email = _emailTextController.text;
    user.password = _passwordTextController.text;
    return user;
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
