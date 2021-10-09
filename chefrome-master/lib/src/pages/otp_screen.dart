import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markets/src/pages/otp_input.dart';
import '../controllers/user_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  final String email;
  final String name;
  final String password;

  OTPScreen({
    this.name,
    this.password,
    this.email,
    Key key,
    @required this.mobileNumber,
  })
      : assert(mobileNumber != null),
        super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends StateMVC<OTPScreen> {
  String val = '';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Control the input text field.
  TextEditingController _pinEditingController = TextEditingController();

  /// Decorate the outside of the Pin.
  PinDecoration _pinDecoration =
  UnderlineDecoration(enteredColor: Colors.black);

  PinDecoration _pp = BoxLooseDecoration(enteredColor: Colors.black);

  bool isCodeSent = false;
  String _verificationId;
  UserController _con;

  _OTPScreenState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    _onVerifyCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .accentColor,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .accentColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: Text(
          'Verification',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Enter 6 Digit verification code sent on your given number ${widget.mobileNumber}",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(32)),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 32, left: 16, right: 16),
                        child: PinInputTextField(
                          pinLength: 6,
                          decoration: _pp,
                          controller: _pinEditingController,
                          autoFocus: true,
                          textInputAction: TextInputAction.done,
                          onChanged: (v) {
                            val = v;
                          },
                          // onSubmit: (pin) {
                          //   if (pin.length == 6) {
                          //     _onFormSubmitted();
                          //   } else {
                          //     showToast("Invalid OTP", Colors.red);
                          //   }
                          // },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (val.length == 6) {
                            _onFormSubmitted();
                          } else {
                            showToast("Invalid OTP", Colors.red);
                          }
                        },
                        child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                ),
                                color: Theme
                                    .of(context)
                                    .accentColor)),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: color,
        textColor: Colors.orange,
        fontSize: 16.0);
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential value) {
        if (value.user != null) {
          _con.user.name = widget.name;
          _con.user.password = widget.password;
          _con.user.email = widget.email;
          _con.user.phone = widget.mobileNumber;
          _con.register();
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => LoginWidget() //HomeScreen()
          //       //  user: value.user,
          //       // ),
          //     ),
          //         (Route<dynamic> route) => false);
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.red);
        //_con.register();
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // TODO: Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.mobileNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    print("on form submitted");
    print("name ${widget.name}");
    print("password ${widget.password}");
    print("email ${widget.email}");
    print("mobiel ${widget.mobileNumber}");
    _con.user.name = widget.name;
    _con.user.password = widget.password;
    _con.user.email = widget.email;
    _con.user.phone = widget.mobileNumber;

    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);
    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((UserCredential value) {
      if (value.user != null) {
        // Handle loogged in state
        _con.register();
        print(value.user.phoneNumber);
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => LoginWidget(), //HomeScreen()
        //       /*HomePage(
        //         user: value.user,
        //       ),*/
        //
        //     ),
        //         (Route<dynamic> route) => false);
      } else {
        showToast("Error validating OTP, try again", Colors.red);
      }
    }).catchError((error) {
      showToast("Something went wrong", Colors.red);
    });
  }
}
