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
  String username = 'username';
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
        title: Text('$username'),
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
            linea(),

            // GENDER + FULL NAME + AGE
            caracteristics(Icons.face, 'full name + age'),

            SizedBox(height: 30.0),

            // CITY, REGION, COUNTRY
            caracteristics(Icons.location_city, 'city, region, country'),

            SizedBox(height: 30.0),

            // LANGUAGE
            caracteristics(Icons.spatial_audio_off, 'language'),

            SizedBox(height: 30.0),

            // LAST LOGIN
            caracteristics(Icons.update, 'last_login'),

            linea(),

            // skill - categoria - nivel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  // skill
                  children: [
                    Text('SKILLS',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    skills('swim'),
                    SizedBox(height: 12.0),
                    skills('draw'),

                  ],
                ),

                SizedBox(width: 20.0,),

                Column(
                  // categoria
                  children: [
                    Text('CATEGORY',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    skills('Sport'),
                    SizedBox(height: 12.0),
                    skills('Creativity'),

                  ],
                ),
                SizedBox(width: 20.0,),
                Column(
                  // categoria
                  children: [
                    Text('NIVEL',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    getThirdText(4),
                    SizedBox(height: 10.0),
                    getThirdText(0),

                  ],
                ),
                SizedBox(width: 20.0,),

              ],
            ),

          ],
        ),

    );
  }


  getIcon(IconData icono) {
    return Icon(
      icono,
      color: Colors.blueGrey[400],
    );}

  caracteristics(IconData icono, String dato_en_cuestion) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 20.0),
        getIcon(icono),
        SizedBox(width: 10.0,),
        Text(
          dato_en_cuestion,
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }

  linea(){
    return Divider(
      height: 60.0,
      color: Colors.blueGrey[400],
      endIndent: 20.0,
      indent: 20.0,
      thickness:1,
    );
  }

  skills(String skill){
    return Text(
      skill,
      style: TextStyle(
        color: Colors.blueGrey[400],
        letterSpacing: 2.0,
      ),
    );
  }

  Text getThirdText(int n) {
    if (n == 0)
      return Text(
        "",

        style:
        TextStyle(color: Colors.blueGrey[400]),
      );
    String res = '★';
    while (n != 1) {
      res = '$res★';
      n--;
    }
    return Text(
      res,
      style: TextStyle(color: Colors.blueGrey[400]),
    );
  }


}

