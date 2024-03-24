import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterloo/app/widgets/main_appbarr.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        resizeToAvoidBottomInset: false,
        appBar: MainAppBar(
          title: "Home",
          backgroundColor: Color(0xffF5F5F5),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              WaterCounter(),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("History"),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("View All"),
                        )
                      ],
                    ),
                    Divider(),
                    Image.asset("assets/logo_blue.png"),
                    Text("You have no history on water intake today.")
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Achievents',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Container WaterCounter() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text(
            "0",
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "/2500mL",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text("Drink (200mL)"),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.terrain,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
