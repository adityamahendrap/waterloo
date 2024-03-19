import 'package:flutter/material.dart';

class OauthButton extends StatelessWidget {
  final String iconPath;
  final String text;

  const OauthButton({
    Key? key,
    required this.iconPath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: SizedBox(
        height: 24,
        child: Image.asset(this.iconPath),
      ),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            this.text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
        shape: StadiumBorder(),
      ),
    );
  }
}
