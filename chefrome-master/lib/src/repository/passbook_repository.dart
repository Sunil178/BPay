import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:markets/src/helpers/helper.dart';
import '../models/passbook.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

// ignore: missing_return
Future<PassBookDetails> getDetails() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return PassBookDetails();
  }
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}wallet/passbook';
  print('walletkonnndaduhaui '+url);
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode({'user_id': _user.id}),
  );
  print(json.encode({'user_id': _user.id}));
  PassBookDetails _passBook =PassBookDetails.fromJson(json.decode(response.body));

  if (response.statusCode == 200) {
    print(_passBook);
    print(response.statusCode);
    print(json.decode(response.body)['status']);
    print(json.decode(response.body));
    return PassBookDetails.fromJson(json.decode(response.body));
  } else {
    throw new Exception(response.body);
  }
}

Future<PassBookDetails> useMoney(double amount) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return PassBookDetails();
  }
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}wallet/sub';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(
        {'user_id': _user.id, 'amount': amount, 'deduction_for': 'order'}),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return PassBookDetails.fromJson(json.decode(response.body));
  } else {
    throw new Exception(response.body);
  }
}

Future<PassBookDetails> userStatement() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return PassBookDetails();
  }
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}wallet/statement';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode({'user_id': _user.id, 'filter_by': 'DEBITED'}),
  );
  if (response.statusCode == 200) {
    print(response.statusCode);
    if(json.decode(response.body)['status']){
      return PassBookDetails.fromJson(json.decode(response.body));
    }else{
      return PassBookDetails.fromJson(json.decode(response.body));
    }
    print(json.decode(response.body));

  } else {
    throw new Exception(response.body);
  }
}

Future<PassBookDetails> addMoney(amount, via) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return PassBookDetails();
  }
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}wallet/add';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body:
        json.encode({'user_id': _user.id, 'amount': amount, 'added_via': via}),
  );
  if (response.statusCode == 200) {
    return PassBookDetails.fromJson(json.decode(response.body));
  } else {
    throw new Exception(response.body);
  }
}

Future<PassBookDetails> userStatementCredit() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return PassBookDetails();
  }
  final String url = '${GlobalConfiguration().getString('api_base_url')}wallet/statement';
  final client = new http.Client();
  final response = await client.post(url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode({'user_id': _user.id, 'filter_by': 'CREDITED'}),
  );
  if (response.statusCode == 200) {
    print(response.statusCode);
    print(json.decode(response.body)['status']);
    return PassBookDetails.fromJson(json.decode(response.body));
  } else {
    throw new Exception(response.body);
  }
}

Future<Stream<PassBookDetails>> getRecentTransactions() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
//  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}wallet/statement';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return PassBookDetails.fromJson(data);
  });
}

Future<PassBookDetails> referralCode() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return PassBookDetails();
  }
  final String url = '${GlobalConfiguration().getString('api_base_url')}app/refer';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body:
    json.encode({'user_id': _user.id,}),
  );
  if (response.statusCode == 200) {
    return PassBookDetails.fromJson(json.decode(response.body));
  } else {
    throw new Exception(response.body);
  }
}