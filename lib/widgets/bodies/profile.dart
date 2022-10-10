import 'package:flutter/material.dart';
// import 'package:skillogue/utils/colors.dart';

void main() {
  runApp(const MaterialApp(
    home: ProfileScreen(),
  ));
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  int ninjaLevel = 0;
  // String username = ;
  // String fullname = ;
  // String country = ;
  // String city = ;
  // String region = ;
  // String gender = ;
  // int age = ;
  // date lastLogin = ;
  // int points =
  // List skills
  // should take everything from the token

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('username'),
        // en vez de meter profile que sea el nombre del user
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState((){
            ninjaLevel+=1;
          });
        },
        child: Icon(Icons.settings),
        backgroundColor: Colors.blueGrey[400],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getIcon(Icons.rowing),
                  SizedBox(width: 10.0,),

                  getIcon(Icons.pedal_bike),
                  SizedBox(width: 10.0,),

                  getIcon(Icons.draw),
                  SizedBox(width: 10.0,),

                  getIcon(Icons.hiking),
                  SizedBox(width: 10.0,),

                ],
              ),
            ),
            Divider(
              height: 90.0,
              color: Colors.white,
              endIndent: 20.0,
              indent: 20.0,
            ),

            // GENDER + FULL NAME + AGE
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20.0),
                getIcon(Icons.face),
                SizedBox(width: 10.0,),
                Text(
                  'full name + AGE',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.0),

            // CITY, REGION, COUNTRY
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getIcon(Icons.location_city),
                SizedBox(width: 10.0,),
                Text(
                  'City, region, country',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.0),

            // LANGUAGE
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getIcon(Icons.spatial_audio_off),
                SizedBox(width: 10.0,),
                Text(
                  'Language',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2.0,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.0),

            // LAST LOGIN
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getIcon(Icons.update),
                SizedBox(width: 10.0,),
                Text(
                  'last login',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.0),

          ],
        ),

    );
  }

  getIcon(IconData icono) {
    return Icon(
      icono,
      color: Colors.blueGrey[400],
    );}

}

