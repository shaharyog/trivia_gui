import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'main.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                      parent: ModalRoute.of(context)!.animation!,
                      curve: Curves.easeInOut,
                    )),
                    child: HomePage(), // Replace MainScreen() with HomePage()
                  );
                },
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeInUp(duration: Duration(milliseconds: 1000), child: Text("Sign up", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),)),
                  SizedBox(height: 20,),
                  FadeInUp(duration: Duration(milliseconds: 1200), child: Text("Create an account, It's free", style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700]
                  ),)),
                ],
              ),
              Column(
                children: <Widget>[
                  FadeInUp(duration: Duration(milliseconds: 1200), child: makeInput(label: "User Name")),
                  FadeInUp(duration: Duration(milliseconds: 1300), child: makeInput(label: "Password", obscureText: true)),
                  FadeInUp(duration: Duration(milliseconds: 1400), child: makeInput(label: "Email")),
                  FadeInUp(duration: Duration(milliseconds: 1500), child: makeInput(label: "Address")),
                  FadeInUp(duration: Duration(milliseconds: 1600), child: makeInput(label: "Phone Number")),
                  FadeInUp(duration: Duration(milliseconds: 1700), child: makeInput(label: "Birthday")),


                ],
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: MaterialButton(
                  minWidth: 400,
                  height: 60,
                  onPressed: () {},
                  color: Color.fromRGBO(159, 182, 163, 1.0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.black), // Apply the border to the button
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,

                      ),
                    ),
                  ),
                ),
              ),

              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account? "),
                        Text("Sign in", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 600, // Set the width of the TextField
          child: TextField(
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey.shade800),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              filled: true, // Enable the background color
              fillColor: Colors.grey.shade200, // Set the background color
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}