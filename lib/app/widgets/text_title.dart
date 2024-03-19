import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTitle extends StatelessWidget {
  final String title;
  const TextTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
