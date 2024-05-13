import 'package:flutter/material.dart';
import 'package:iot_app/screen/login.dart';
import 'package:iot_app/screen/register.dart';
import 'package:iot_app/widgets/Button/button_log.dart';
import 'package:iot_app/widgets/Button/button_social.dart';
import 'package:iot_app/widgets/Text/text_title.dart';


class WellcomeScreen extends StatefulWidget {
  @override
  _wellcomeScreenState createState() => _wellcomeScreenState();
}

class _wellcomeScreenState extends State<WellcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 248, 250, 1),
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 150),
            const SizedBox(
              child: TitleTextWidget(text: "Wellcome to"),
            ),
            const SizedBox(
              child: TitleTextWidget(text: "RISCS Lab"),
            ),
            const SizedBox(
              height: 250,
            ),
            ButtonLogWidget(
              colorButton: Color.fromARGB(255, 9, 11, 90),
              colorText: Colors.white,
              screenToNavigate: LoginScreen(),
              text: "Log in",
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonLogWidget(
              colorButton: Color.fromARGB(255, 255, 255, 255),
              colorText: Color.fromARGB(255, 150, 147, 147),
              screenToNavigate: RegisterScreen(),
              text: "Sign up",
            ),
             const SizedBox(
              height: 30,
            ),
           
            
            SocialButtonRow(
              onGooglePressed: (){},
             onFacebookPressed: (){}
             ),


          ],
        ),
      ),
    ));
  }
}
