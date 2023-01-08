import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skillogue/entities/conversation_entity.dart';
import 'package:skillogue/entities/profile_entity.dart';
import 'package:skillogue/entities/profile_search_entity.dart';
import 'package:skillogue/utils/misc_functions.dart';
import 'package:skillogue/utils/responsive_layout.dart';

import '../../utils/backend/misc_backend.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../home_screen.dart';

class ResultSearchScreen extends StatefulWidget {
  final List<Profile> profileSearchResults;

  const ResultSearchScreen(this.profileSearchResults, {super.key});

  @override
  State<ResultSearchScreen> createState() => _ResultSearchScreenState();
}

class _ResultSearchScreenState extends State<ResultSearchScreen> {
  final newMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 4,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          appName,
          style: GoogleFonts.bebasNeue(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.profileSearchResults.length,
        itemBuilder: (context, index) {
          return ResponsiveLayout(
            mobileBody: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: searchResultsList(index)),
            tabletBody: Padding(
                padding: const EdgeInsets.only(left: 200, right: 200, top: 10),
                child: searchResultsList(index)),
            desktopBody: Padding(
                padding: const EdgeInsets.only(left: 300, right: 300, top: 10),
                child: searchResultsList(index)),
          );
        },
      ),
    );
  }

  searchResultsList(index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
      ),
      child: Column(
        children: [
          ListTile(
            key: Key("result"),
            leading: getAvatar(widget.profileSearchResults[index].name,
                widget.profileSearchResults[index].points, 30, 1.5, 0, 10),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return sendNewMessage(
                      widget.profileSearchResults[index].email,
                      widget.profileSearchResults[index].name,
                      widget.profileSearchResults[index].points,
                      index);
                },
              );
            },
            title: Column(
              children: [
                addVerticalSpace(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " ${widget.profileSearchResults[index].name}",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                addVerticalSpace(4),
                profileDescription(widget.profileSearchResults[index], 12,
                    Colors.white.withOpacity(0.8), true, true),
              ],
            ),
            subtitle: Align(
              alignment: Alignment.center,
              child: Wrap(
                spacing: 3.0,
                runSpacing: -10,
                alignment: WrapAlignment.start,
                children: chippies(widget.profileSearchResults[index].skills,
                    widget.profileSearchResults[index].languages, 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  sendNewMessage(String destEmail, String destName, int destPoints, int index) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        title: Text(AppLocale.sendMessage.getString(context) + destName),
        content: TextField(
          controller: newMessageController,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(40.0),
            ),
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromRGBO(30, 30, 30, 1)
                : const Color.fromRGBO(235, 235, 235, 1),
            hintText: AppLocale.typeMessage.getString(context),
            hintStyle:
                TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
            filled: true,
            suffixIcon: const Icon(Icons.message,
                color: Color.fromRGBO(129, 129, 129, 1)),
          ),
        ),
        actions: [
          TextButton(
            child: Text(AppLocale.ok.getString(context)),
            onPressed: () {
              String newTextMessage = newMessageController.text.trim();
              if (newTextMessage.isNotEmpty) {
                newMessageController.clear();
                DateTime curDate = DateTime.now();
                databaseInsert('message', {'sender': profile.email, 'receiver': destEmail, 'text': newTextMessage, 'date': curDate.toString()});
                conversations.add(Conversation(destEmail, destName, destPoints, [SingleMessage(0,newTextMessage,curDate,true,)]));
                setState(() {
                  widget.profileSearchResults.removeAt(index);
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
