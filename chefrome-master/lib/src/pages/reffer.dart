import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:lottie/lottie.dart';
import '../models/custom_fieldsss.dart';
import '../repository/user_repository.dart';
import 'package:provider/provider.dart';
import '../repository/passbook_repository.dart';
import '../models/verify_referal_code.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class Reffer extends StatefulWidget {
  @override
  _RefferState createState() => _RefferState();
}

class _RefferState extends State<Reffer> {
  User _user;
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;

  Map<String, dynamic> referral;

  String code;

  void enterCode(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('We\'re so delighted you\'re here!'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/img/gift_gif.json',
                    height: 100,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 150,
                    child: Text(
                      'Collect Your Gift On Entering Invite Code',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text(
                      'Enter Invite Code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).accentColor.withOpacity(.7),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width - 200,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          onSaved: (value) {
                            code = value;
                          },
                          decoration: InputDecoration(prefixText: '#'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field is required';
                            }
                            if (value.length < 5) {
                              print(value.contains('#'));
                              return 'Please enter valid code';
                            }
                            // if (value.contains('#') == false) {
                            //   return 'Please enter valid code';
                            // }
                            return null;
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        getVerifiedCode();
                        print(code);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'REDEEM NOW!',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).accentColor.withOpacity(.7),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> getVerifiedCode() async {
    String url =
        '${GlobalConfiguration().getString('api_base_url')}refer_code/$code/${_user.id}';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      final verifycode = verifyReferalCodeFromJson(response.body);
      print(verifycode.msg.toString());

      if (verifycode.msg == 'Code Applied') {
        print(true);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: ClipOval(
              child: Image.asset('assets/img/right_gif.gif'),
            ),
            content: Text(
              'Referal code verified successfully',
              textAlign: TextAlign.center,
            ),
          ),
        );
        Future.delayed(Duration(seconds: 2))
            .then((value) => Navigator.pop(context));
      } else {
        print('false');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: ClipOval(
              child: Image.asset('assets/img/wrong_gif.gif'),
            ),
            content: Text(
              'Referal code verified fail',
              textAlign: TextAlign.center,
            ),
          ),
        );
        Future.delayed(Duration(seconds: 2))
            .then((value) => Navigator.pop(context));
      }
    }
    print('res code' + response.statusCode.toString());
    print('efewfw' + response.body);
  }

  Future<void> getStatements() async {
    var result = await referralCode().then((result) {
      setState(() {
        referral = result.data;
        print(referral);
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatements();
    _user = currentUser.value;
  }

  @override
  Widget build(BuildContext context) {
    print('dsvdsvsdv' + _user.id);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Share the love'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/img/invite_gif.json',
                  width: 200,
                ),
              ),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Text(
                  'Invite friend and both of you will get ₹${Provider.of<CustomFieldsss>(context, listen: false).getReferalMoney} on your wallet.',
                  textAlign: TextAlign.center,
                  // style: TextStyle(
                  //   fontSize: 22,
                  //   fontWeight: FontWeight.w600,
                  // ),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(
                height: 64,
              ),
              Text(
                'Share your code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).accentColor.withOpacity(.8),
                ),
              ),
              Divider(),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black45)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Share.share(
                              'This is my referal code : ${referral['user_refer_code']} \nHere is my app link:\nhttps://play.google.com/store/apps/details?id=com.ssoftwares.onlinehappylifeadmin');
                        },
                        child: Text(
                            _isLoading
                                ? '- - - - - - - '
                                : '${referral['user_refer_code']}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.insert_invitation,
                        color: Theme.of(context).accentColor,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  enterCode(context);
                },
                child: Text(
                  'Enter code here',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
