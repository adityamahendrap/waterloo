import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:waterloo/app/controllers/auth_controller.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;

  final authC = AuthController();

  MainAppBar({
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
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            customButton: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.more_vert,
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ),
            items: [
              ...MenuItems.firstItems.map(
                (item) => DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
              ),
              const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
              ...MenuItems.secondItems.map(
                (item) => DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
              ),
            ],
            onChanged: (value) {
              MenuItems.onChanged(context, value! as MenuItem);
            },
            dropdownStyleData: DropdownStyleData(
              width: 160,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              elevation: 2,
              offset: const Offset(-140, 0),
            ),
            menuItemStyleData: MenuItemStyleData(
              customHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              padding: const EdgeInsets.only(left: 16, right: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [home];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Home', icon: Icons.home_outlined);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.blue, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      // case MenuItems.home:
      //   break;
      // case MenuItems.settings:
      //   break;
      // case MenuItems.share:
      //   break;
      case MenuItems.logout:
        AuthController().logout();
        break;
    }
  }
}
