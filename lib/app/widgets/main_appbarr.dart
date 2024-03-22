import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;

  const MainAppBar({
    Key? key,
    required this.title,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: this.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          height: 24,
          width: 24,
          child: Image.asset("assets/logo_blue.png"),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          Get.back();
        },
      ),
      title: Center(
        child: Text(
          this.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            height: 24,
            width: 24,
            child: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}
