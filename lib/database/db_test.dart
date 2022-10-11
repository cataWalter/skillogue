
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:skillogue/entities/profile.dart';
import 'package:skillogue/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);
  var x = Profile("1", "dasdsa", "dasdsa", "dasdsa", "dasdsa", 1, 1, 1,
      1, DateTime.now());
  x.newProfileUpload();
  List<Profile> newResults = await queryByUsername("1");
  print(newResults.length);

}